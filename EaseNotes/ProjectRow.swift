//
//  Project Rows.swift
//  EaseNotes
//
//  Created by David Ford on 11/12/24.
//

import SwiftUI

struct ProjectRow: View {
    let project: Project
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(project.title)
                    .font(.headline)
                Spacer()
                Image(systemName: "note.text")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25,
                           height: 30)
                    .foregroundColor(Color .green)
                    .shadow(
                        color: Color.gray,
                        radius: 100
                        //x:0,
                        //y:0
                    )
            }
            .padding()
            Text(project.content)
                .font(.body)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.8))
                .shadow(radius: 2)
        )
        .padding(.horizontal)
        .padding(.bottom)
    }
}

#Preview {
    ProjectRow(project: Project(title: "Project 1", description: "11111", createdAt: Date())
    )
}
