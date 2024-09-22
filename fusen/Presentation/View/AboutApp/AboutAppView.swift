//
//  AboutAppView.swift
//  fusen
//
//  Created by Tatsuyuki Kobayashi on 2022/08/16.
//

import SwiftUI

struct AboutAppView: View {
    var body: some View {
        VStack {
            TabView {
                PageViewOne()
                    .tabItem {
                        Image(systemName: "circle.fill")
                    }
                PageViewTwo()
                    .tabItem {
                        Image(systemName: "circle.fill")
                    }
                PageViewThree()
                    .tabItem {
                        Image(systemName: "circle.fill")
                    }
                PageViewFour()
                    .tabItem {
                        Image(systemName: "circle.fill")
                    }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .navigationBarTitle("アプリの便利な使い方", displayMode: .inline)
    }
}

struct AboutAppView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutAppView()
        }
    }
}

private extension AboutAppView {
    struct PageHeader: View {
        private let title: String

        init(title: String) {
            self.title = title
        }

        var body: some View {
            Text(title)
                .font(.medium.bold())
                .foregroundColor(.textPrimary)
        }
    }

    struct PageItem: View {
        private let text: String

        init(_ text: String) {
            self.text = text
        }

        var body: some View {
            HStack(alignment: .top, spacing: 4) {
                Text("・")
                    .font(.medium.bold())
                    .foregroundColor(.textPrimary)
                Text(text)
                    .font(.medium)
                    .foregroundColor(.textPrimary)
            }
        }
    }

    struct PageImage: View {
        private let imageName: String

        init(_ imageName: String) {
            self.imageName = imageName
        }

        var body: some View {
            Image(imageName)
                .resizable()
                .frame(width: 134, height: 240)
                .scaledToFill()
                .clipped()
                .border(Color.border, width: 1)
        }
    }

    struct PageViewOne: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                PageHeader(title: "書籍を「読書中」に設定")
                VStack(alignment: .leading, spacing: 12) {
                    PageItem("ホームタブに読書中の書籍が表示されます")
                    PageItem("書籍のメモを作成しやすくなります")
                    Spacer()
                    HStack {
                        Spacer()
                        PageImage("img_about_app_1")
                        Spacer()
                    }
                }
            }
            .padding(.init(top: 12, leading: 24, bottom: 60, trailing: 24))
        }
    }

    struct PageViewTwo: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                PageHeader(title: "PCと共有")
                VStack(alignment: .leading, spacing: 12) {
                    PageItem("https://fusen.app/ へアクセスすると、PCなどのブラウザでもメモを確認できます。")
                    PageItem("アプリと書籍やメモを共有するにはログインが必要です。")
                    Link("ブラウザで開く", destination: URL(string: "https://fusen.app/")!)
                        .font(.medium)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(16)
                    Spacer()
                    HStack {
                        Spacer()
                        PageImage("img_about_app_5")
                        Spacer()
                    }
                }
            }
            .padding(.init(top: 12, leading: 24, bottom: 60, trailing: 24))
        }
    }

    struct PageViewThree: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                PageHeader(title: "ウィジェット表示")
                VStack(alignment: .leading, spacing: 12) {
                    PageItem("ウィジェットに読書中の書籍を表示し、読み忘れを防げます")
                    PageItem("ウィジェットからアプリを起動してメモを作成できます")
                    Spacer()
                    HStack {
                        Spacer()
                        PageImage("img_about_app_2")
                        Spacer()
                    }
                }
            }
            .padding(.init(top: 12, leading: 24, bottom: 60, trailing: 24))
        }
    }

    struct PageViewFour: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                PageHeader(title: "他のアプリからメモを作成")
                VStack(alignment: .leading, spacing: 12) {
                    PageItem("Kindleなどの他のアプリのテキストを引用してメモを作成できます")
                    HStack(alignment: .top, spacing: 4) {
                        Text("・")
                            .font(.medium.bold())
                            .foregroundColor(.textPrimary)
                        Text("テキストを選択して\(Image(systemName: "square.and.arrow.up")) アイコンから共有し、「読書メモ」を選択します")
                            .font(.medium)
                            .foregroundColor(.textPrimary)
                    }
                    PageItem("共有したメモは読書中の書籍のメモに追加されます")
                    Spacer()
                    HStack(spacing: 8) {
                        Spacer()
                        PageImage("img_about_app_3")
                        PageImage("img_about_app_4")
                        Spacer()
                    }
                }
            }
            .padding(.init(top: 12, leading: 24, bottom: 60, trailing: 24))
        }
    }
}
