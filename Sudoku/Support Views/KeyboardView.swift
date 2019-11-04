//
//  KeyboardView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 30/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

struct KeyboardView: View {
	@EnvironmentObject var _grid: Grid
	@Binding var _isPaused: Bool
	
	@State private var deleteAlert = false
	@State private var overwriteAlert = false
	
	var body: some View {
		VStack {
			
			if (deleteAlert) {
				Spacer()
				Text("Impossível remover valor pré-definido")
					.font(.custom("CaviarDreams-Bold", size: 15))
				Spacer()
			} else if (overwriteAlert) {
				Spacer()
				Text("Impossível sobrescrever valor pré-definido")
					.font(.custom("CaviarDreams-Bold", size: 15))
				Spacer()
			}
			
			HStack {
				Spacer()
				Button(
					action: {

					},
					label: {
						VStack {
							Image(systemName: "gobackward")
								.resizable()
								.frame(width: Screen.cellWidth / 2,
									   height: Screen.cellWidth / 2)
							Text("Anular")
								.font(.custom("CaviarDreams-Bold",
											  size: Screen.cellWidth / 2))
						}
							.foregroundColor(Colors.MatteBlack)
					}
				)
				Spacer()
				Button(
					action: {
						guard let active = self._grid.getActive()
						else { return }
						
						if self._grid.deleteValue(row: active[0],
												  col: active[1]) == false {
							// failed to delete default value
							self.deleteAlert = true
							DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
								self.deleteAlert = false
							}
							
						} else {
							self._grid.objectWillChange.send()
						}
					},
					label: {
						VStack {
							Image(systemName: "xmark.circle")
								.resizable()
								.frame(width: Screen.cellWidth / 2,
									   height: Screen.cellWidth / 2)
								.foregroundColor(Colors.EraserPink)
							Text("Apagar")
								.font(.custom("CaviarDreams-Bold",
											  size: Screen.cellWidth / 2))
								.foregroundColor(Colors.MatteBlack)
						}
					}
				)
				Spacer()
			}
				.padding(.top)
				.padding(.bottom)
			
			HStack {
				ForEach(1 ..< 10) { i in
					Spacer()
					Button(
						action: {
							guard
								let active = self._grid.getActive()
							else {
								return
							}
							
							self._grid.cellAt(row: active[0],
											  col: active[1]).setValue(value: i)
							self._grid.cellAt(row: active[0],
											  col: active[1]).setUserInput(userInput: true)
							self._grid.objectWillChange.send()
						},
						label: {
							Text("\(i)")
								.foregroundColor(Colors.MatteBlack)
								.font(.custom("CaviarDreams-Bold",
											  size: Screen.cellWidth))
						}
					)
				}
				Spacer()
			}
				.padding(.top)
				.padding(.bottom)
				.padding(.leading, -5)
		}
			.blur(radius: _isPaused ? 5 : 0)
			.opacity(_isPaused ? 0.7 : 1)
			.disabled(_isPaused)
			.animation(.spring())
	}
}
