//
//  DropViewDelegate.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 2/15/24.
//
import SwiftUI
import UniformTypeIdentifiers

struct DropViewDelegate: DropDelegate {
    
    let destinationItem: Video
    @Binding var videos: [Video]
    @Binding var draggedItem: Video?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        // Swap Items
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        if let draggedItem {
            if (draggedItem.category == destinationItem.category) {
                let fromIndex = videos.firstIndex(of: draggedItem)
                if let fromIndex {
                    let toIndex = videos.firstIndex(of: destinationItem)
                    if let toIndex, fromIndex != toIndex {
                        impactMed.impactOccurred()
                        withAnimation {
                            self.videos.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                        }
                    }
                }
            }
        }
    }
}
