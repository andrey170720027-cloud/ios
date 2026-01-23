//
//  SearchResultsView.swift
//  IOS3
//
//  Компонент для отображения результатов поиска
//

import SwiftUI

struct SearchResultsView: View {
    let searchResults: [SearchResult]
    let viewForSection: (String) -> AnyView
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                if searchResults.isEmpty {
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "Ничего не найдено",
                        message: nil
                    )
                    .padding(.top, 100)
                } else {
                    let sections = searchResults.filter {
                        if case .section = $0.type { return true }
                        return false
                    }
                    
                    let products = searchResults.filter {
                        if case .product = $0.type { return true }
                        return false
                    }
                    
                    if !sections.isEmpty {
                        Text("Разделы")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        
                        ForEach(sections) { result in
                            if case .section(let sectionName) = result.type {
                                NavigationLink(destination: viewForSection(sectionName)) {
                                    HStack {
                                        Image(systemName: "folder.fill")
                                            .foregroundColor(.blue)
                                            .frame(width: 24)
                                        Text(sectionName)
                                            .font(.system(size: 16))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(Color.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    if !products.isEmpty {
                        Text("Товары")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.top, sections.isEmpty ? 8 : 16)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 16) {
                            ForEach(products) { result in
                                if case .product(let product) = result.type {
                                    NavigationLink(destination: ProductDetailView(product: product)) {
                                        ProductCardView(product: product)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.bottom, 80)
        }
    }
}
