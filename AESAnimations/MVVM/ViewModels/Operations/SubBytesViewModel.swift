//
//  SubBytesViewModel.swift
//  AESAnimations
//
//  Created by Leon Chamoun on 15.08.24.
//

import SwiftUI

class SubBytesViewModel: AnimationViewModel {
    // MARK: - Properties
    let operationDetails: OperationDetails
    
    // State Properties
    @Published var state: [[Byte]]
    let result: [[Byte]]
    let copyOfMatrix: [[Byte]]
    
    // Flags for CurrentByte which is substituted
    @Published var currentByte: Byte = 0x00
    @Published var currentStateSubBytes: [[Bool]] = Array.create2DArray(repeating: false,
                                                                        rows: 4,
                                                                        cols: 4)
    @Published var positions: [[Position]] = Position.default2DPositions(rows: 4,
                                                                         cols: 4)
    
    // Properties for the S-Box View
    @Published var searchResult: Byte? = nil
    @Published var searchState: Double = 0
    @Published var searchStatePosition: Position
    @Published var searchX: Byte? = nil
    @Published var searchY: Byte? = nil
    
    // Modifier for Searching the Byte in the S-Box
    @Published var splitByte: [[Bool]] = Array.create2DArray(repeating: false, rows: 4, cols: 4)
    
    @Published var showSBoxAnimation = false
    
    // Task und Steps Handler
    @Published var animationControl: AnimationControl
    var animationData = AnimationData()
    
    // Helper Variables for View and Calculating the S-Box
    private let boxSize = 50
    
    // Computed Properties
    var sBoxAnimationViewModel: SBoxAnimationViewModel {
        var copyOfOperationDet = operationDetails
        copyOfOperationDet.operationName = operationDetails.isInverseMode ? .invSBox : .sBox
        copyOfOperationDet.currentRound = -1
        
        return SBoxAnimationViewModel(operationDetails: copyOfOperationDet)
    }
    
    // MARK: - Initializer
    init(state: [[Byte]],
         result: [[Byte]],
         operationDetails: OperationDetails,
         animationControl: AnimationControl = AnimationControl()) {
        self.state = state
        self.result = result
        self.operationDetails = operationDetails
        self.animationControl = animationControl
        
        self.searchStatePosition = Position(x: -1, y: -1)
        copyOfMatrix = state
    }
    
    // MARK: - Animation Steps Creation
    /// Creates the animation steps for the entire animation sequence.
    ///
    /// This function is called when the view appears, and it ensures that the `animationSteps` and `reverseAnimationSteps` arrays
    /// are filled only once.
    ///
    /// - Parameter geometry: The `GeometryProxy` object used to calculate the view's layout for positioning animations.
    @MainActor
    func createAnimationSteps(with geometry: GeometryProxy) {
        // The state position is further to the left and slightly above the center. Therefore, a cell
        // is shifted by 75 units along the x-axis and its height is adjusted by 35% on the y-axis.
        var position = Position(x: geometry.size.width * 0.75,
                                y: geometry.size.height * 0.35)
        
        #if os(iOS)
        position.y = geometry.size.height * 0.32 // Position on iPad is too high
        #endif
        
        // The calculation was made as follows:
        // The text "Search State" should display the position where the "Cell" is located,
        // but further to the left, leaving enough space for the text. The centering
        // should also be maintained to keep the layout consistent.
        searchStatePosition = Position(x: position.x - CGFloat(3 * boxSize),
                                       y: -(position.y + CGFloat(3 * boxSize + 40)))
        
        for row in 0..<state.count {
            for col in 0..<state[row].count {
                let animations = processGridCell(row: row, col: col, targetPosition: position)
                animationData.animationSteps.append(contentsOf: animations.0)
                animationData.reverseAnimationSteps.append(contentsOf: animations.1)
            }
        }
        
        handleAnimationStart()
    }
    
    /// Processes a specific grid cell in the state by animating its movement and updating its state.
    ///
    /// This function performs a series of animations to move the cell to a target position,
    /// conduct a search operation, and then reset the cell's position. It returns two sets of animation steps:
    /// one for the forward animation and one for reversing the operation.
    ///
    /// - Parameters:
    ///   - row: The row index of the state where the animation occurs.
    ///   - col: The column index of the state where the animation occurs.
    ///   - targetPosition: The target `Position` where the cell will be animated.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///            and the second array handles the reverse animation.
    @MainActor
    private func processGridCell(row: Int, col: Int, targetPosition: Position) -> ([AnimationStep], [AnimationStep]) {
        var normalSteps = [
            AnimationStep(animation: { self.changeCurrentBytes(row: row, col: col, to: (self.state[row][col], true)) },
                          delay: normal)
        ]
        
        var reverseSteps = [AnimationStep { self.changeCurrentBytes(row: row, col: col, to: (0x00, false)) }]
        
        let newPosition = Position(
            x: targetPosition.x - CGFloat(col * boxSize),
            y: -(targetPosition.y + CGFloat(row * boxSize))
        )
        
        let cellMovements = animateCellMovement(row: row, col: col, to: newPosition)
        let searchSteps = performSearchAndUpdate(row: row, col: col)
        let resetSteps = resetCellPosition(row: row, col: col, to: newPosition)
        
        normalSteps.append(contentsOf: cellMovements.0 + searchSteps.0 + resetSteps.0)
        reverseSteps.append(contentsOf: cellMovements.1 + searchSteps.1 + resetSteps.1)
        
        return (normalSteps, reverseSteps)
    }
    
    // MARK: - Animation Steps Creation Helper Functions
    /// Animates the movement of a cell in the state to a specified position.
    ///
    /// This function generates a series of animation steps to move a cell to a new `Position` within the state,
    /// and also defines steps to reverse the movement, returning the cell to its original position.
    ///
    /// - Parameters:
    ///   - row: The row index of the state where the animation occurs.
    ///   - col: The column index of the state where the animation occurs.
    ///   - newPosition: The new `Position` where the cell will be animated.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///            and the second array handles the reverse animation.
    @MainActor
    private func animateCellMovement(row: Int, col: Int, to newPosition: Position) -> ([AnimationStep], [AnimationStep]) {
        let normalSteps = [
            AnimationStep(animation: { await self.changePosition(row: row, col: col, y: newPosition.y) }, delay: short),
            AnimationStep(animation: { await self.changePosition(row: row, col: col, x: newPosition.x) }, delay: short)
        ]
        
        let reverseSteps = [
            AnimationStep(animation: { await self.changePosition(row: row, col: col, y: 0) }, delay: short),
            AnimationStep(animation: { await self.changePosition(row: row, col: col, x: 0) }, delay: short),
        ]
        
        return (normalSteps, reverseSteps)
    }
    
    /// Performs a search operation for a specific cell in the state and updates its state.
    ///
    /// This function animates the search process by splitting the byte, searching for its x and y components,
    /// and displaying the search result. It also defines the reverse animation to undo the search operation and reset the state.
    ///
    /// - Parameters:
    ///   - row: The row index of the state where the animation occurs.
    ///   - col: The column index of the state where the animation occurs.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///            and the second array handles the reverse animation.
    @MainActor
    private func performSearchAndUpdate(row: Int, col: Int) -> ([AnimationStep], [AnimationStep]) {
        let normalSteps = [
            AnimationStep(animation: { withAnimation { self.searchState = 1.0 } }, delay: normal),
            AnimationStep(animation: { withAnimation { self.splitByte[row][col] = true } }, delay: short),
            AnimationStep(animation: { withAnimation { self.searchX = (self.state[row][col] & 0xF0) >> 4 } }, delay: short),
            AnimationStep(animation: { withAnimation { self.searchY = self.state[row][col] & 0x0F } }, delay: normal),
            AnimationStep(animation: { withAnimation { self.searchResult = self.currentByte } }, delay: normal)
        ]
        
        let reverseSteps = [
            AnimationStep(animation: { withAnimation { self.searchState = 0.0 } }, delay: normal),
            AnimationStep(animation: { withAnimation { self.splitByte[row][col] = false } }, delay: short),
            AnimationStep(animation: { withAnimation { self.searchX = nil } }, delay: short),
            AnimationStep(animation: { withAnimation { self.searchY = nil } }, delay: normal),
            AnimationStep(animation: { withAnimation { self.searchResult = nil } }, delay: normal),
        ]
        
        let updateSteps = updateGridStateAndResetSearch(row: row, col: col)
        
        return (normalSteps + updateSteps.0, reverseSteps + updateSteps.1)
    }
    
    /// Resets the position of a specific cell in the state to its original or specified position.
    ///
    /// This function defines the forward animation to reset the cell's position back to its initial state (x: 0, y: 0),
    /// as well as the reverse animation, which moves the cell back to a given `Position`, typically used to undo the reset.
    ///
    /// - Parameters:
    ///   - row: The row index of the state where the animation occurs.
    ///   - col: The column index of the state where the animation occurs.
    ///   - position: The `Position` where the cell will be animated (used for the reverse animation).
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///            and the second array handles the reverse animation.
    @MainActor
    private func resetCellPosition(row: Int, col: Int, to position: Position) -> ([AnimationStep], [AnimationStep]) {
        let normalSteps = [
            AnimationStep(animation: { await self.changePosition(row: row, col: col, x: 0) }, delay: short),
            AnimationStep(animation: { await self.changePosition(row: row, col: col, y: 0) }, delay: normal)
        ]
        
        let reverseSteps = [
            AnimationStep(animation: { await self.changePosition(row: row, col: col, x: position.x) }, delay: normal),
            AnimationStep(animation: { await self.changePosition(row: row, col: col, y: position.y) }, delay: normal)
        ]
        
        return (normalSteps, reverseSteps)
    }
    
    /// Updates the state of the grid and resets the search values for a specific cell.
    ///
    /// This function modifies the state of the grid based on the result, and also resets the search state
    /// by clearing or setting the relevant search values. It returns two arrays of animation steps:
    /// one for the forward animation to update and reset the state, and another for reversing these changes.
    ///
    /// - Parameters:
    ///   - row: The row index of the state where the animation occurs.
    ///   - col: The column index of the state where the animation occurs.
    /// - Returns: A tuple containing two arrays of `AnimationStep` objects. The first array handles the forward animation,
    ///            and the second array handles the reverse animation.
    @MainActor
    private func updateGridStateAndResetSearch(row: Int, col: Int) -> ([AnimationStep], [AnimationStep]) {
        let normalSteps = [
            AnimationStep(animation: { self.modifyState(row: row, col: col, for: (self.result[row][col], false)) }, delay: short),
            AnimationStep(animation: { self.setSearchState(for: (nil, nil, nil), showText: 0) }, delay: short)
        ]
        
        let reverseSteps = [
            AnimationStep(animation: { self.modifyState(row: row, col: col, for: (self.copyOfMatrix[row][col], true)) }, delay: short),
            AnimationStep(animation: { self.setSearchState(for: (self.copyOfMatrix[row][col],
                                                                (self.copyOfMatrix[row][col] & 0xF0) >> 4,
                                                                 self.copyOfMatrix[row][col] & 0x0F),
                                                           showText: 1)
            }, delay: normal)
        ]
        
        return (normalSteps, reverseSteps)
    }
    
    // MARK: - Modifier Helper Functions
    /// Updates the current byte and its visibility state for a specific cell in the state.
    ///
    /// This function animates the process of changing the byte and its corresponding state for the given cell,
    /// either showing or hiding the byte based on the provided value.
    ///
    /// - Parameters:
    ///   - row: The row index of the state where the animation occurs.
    ///   - col: The column index of the state where the animation occurs.
    ///   - value: A tuple containing the new `Byte` value and a `Bool` indicating whether the byte should be visible (true) or hidden (false).
    private func changeCurrentBytes(row: Int, col: Int, to value: (Byte, Bool)) {
        withAnimation {
            self.currentByte = value.0
            self.currentStateSubBytes[row][col] = value.1
        }
    }
    
    /// Modifies the state of a specific cell in the state by updating its byte value and splitting state.
    ///
    /// This function animates the update of the byte value for the given cell, and sets whether the byte should be split
    /// or not, based on the provided value.
    ///
    /// - Parameters:
    ///   - row: The row index of the state where the animation occurs.
    ///   - col: The column index of the state where the animation occurs.
    ///   - value: A tuple containing the new `Byte` value and a `Bool` indicating whether the byte should be split (true) or not (false).
    private func modifyState(row: Int, col: Int, for value: (Byte, Bool)) {
        withAnimation {
            self.state[row][col] = value.0
            self.splitByte[row][col] = value.1
        }
    }
    
    /// Sets the search state, including the result and the x and y components of the search operation.
    ///
    /// This function animates the update of the search state, displaying the search result and its corresponding x and y coordinates,
    /// and optionally controls the visibility of the search text based on the `showText` parameter.
    ///
    /// - Parameters:
    ///   - resultXY: A tuple containing the optional `Byte` values for the search result, x coordinate, and y coordinate.
    ///   - showText: A `Double` value that determines whether the search text should be visible (typically 1.0 for visible, 0.0 for hidden).
    private func setSearchState(for resultXY: (Byte?, Byte?, Byte?), showText: Double) {
        withAnimation {
            searchState = showText
            searchResult = resultXY.0
            searchX = resultXY.1
            searchY = resultXY.2
        }
    }
    
    /// Changes the position of a specific cell in the state by updating its x and/or y coordinates.
    ///
    /// This function animates the movement of the cell, updating either the x, y, or both coordinates based on the provided values.
    /// If a coordinate is not provided, it remains unchanged. After the position change, the function checks for double animations.
    ///
    /// - Parameters:
    ///   - row: The row index of the state where the animation occurs.
    ///   - col: The column index of the state where the animation occurs.
    ///   - x: An optional `CGFloat` representing the new x-coordinate of the cell. If nil, the x position remains unchanged.
    ///   - y: An optional `CGFloat` representing the new y-coordinate of the cell. If nil, the y position remains unchanged.
    @MainActor
    private func changePosition(row: Int, col: Int, x: CGFloat? = nil, y: CGFloat? = nil) async {
        await checkDoubleAnimation(for: self.short)
        if Task.isCancelled { return }
        
        withAnimation {
            if let x = x {
                positions[row][col].x = x
            }
            
            if let y = y {
                positions[row][col].y = y
            }
        }
    }
    
    // MARK: - Animation Controler Functions
    /// Resets all variables related to the animation to their initial state.
    ///
    /// This function reinitializes the state of various animation-related variables, such as the positions of
    /// the cells, visibility flags. It is used to reset the animation to the starting point.
    /// The `newState` parameter is included for  state modification after the animation.
    ///
    /// - Parameters:
    ///   - newState: The modified state after the animation.
    ///   - showResult: Controls whether the new state is visible or not after resetting.
    func resetAnimationState(state newState: [[Byte]], showResult: Double) {
        setSearchState(for: (nil, nil, nil), showText: 0)
        currentByte = 0x00
        splitByte = Array.create2DArray(repeating: false, rows: 4, cols: 4)
        currentStateSubBytes = Array.create2DArray(repeating: showResult == 1.0 ? true : false, rows: 4, cols: 4)
        state = newState
        
        withAnimation { positions = Position.default2DPositions(rows: 4, cols: 4) }
    }
    
    // MARK: - UI Helper Functions
    /// Determines the background color of a specific cell in the state based on its active state.
    ///
    /// This function checks whether the cell is in the active state (`currentStateSubBytes`).
    /// If the cell is active, it returns the `activeByteColor` for the cell's value.
    /// If the cell is not active, it returns the `reducedByteColor`.
    ///
    /// - Parameters:
    ///   - row: The row index of the state where the background color is being determined.
    ///   - col: The column index of the state where the background color is being determined.
    /// - Returns: The `Color` to be used as the background for the cell.
    func backgroundColor(row: Int, col: Int) -> Color {
        let value = state[row][col]
        let isActiveState = currentStateSubBytes[row][col]
        
        if isActiveState { return .activeByteColor(value, to: 0.8) }
        
        return .reducedByteColor(value)
    }
    
    func toggleSBoxAnimation() {
        showSBoxAnimation.toggle()
    }
}
