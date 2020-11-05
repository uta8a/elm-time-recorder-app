# ElmTodoTimeApp

# License
- Signika font(public/Signika-Bold.ttf): SIL OFL 1.1 (googlefont)
- other code: MIT

# Elm入門して消費時間記録サービス作る
- 以下のようにやっていった(npmはいれている前提)
```shell
$ npm install create-elm-app -g
$ npm install elm -g
$ npm install -g elm-test # test for VSCode
$ create-elm-app time-recorder
$ cd time-recorder

$ elm-app start # start local server
$ elm-app build # build for production
$ elm-app test # test 

```
- testのためのclassとスタイルのためのclassの名前空間を分離する。
- testはclass `test-` プレフィックスをつける
- HtmltoElmを使うと、HTML部分が楽
- Test先と言っても、何もないときついので、Modelとかの定義部分を書いて中身を書く前にテスト書くみたいなノリがいいかもしれない。
- CSSは今回は型つけないことにする
- Backlog的にしたらいいかなと思ったけど、Project管理は別でやるのでシンプルさを大事にすることにした。
- localStorageを使ったportができた
- https://www.codebu.org/posts/tailwind-setup/ に従って、ローカルでCSSを生成する方針でtailwind導入
- `npx tailwindcss build styles.css -o output.css` をすればOK
- classについてちょっとおもしろい挙動。
  - `[class "a", class "b"]` はclassListとして扱われて複数クラスに変換される `<button class="bb test-button-plus">`
  - しかし、`[class "a b"]`も同じように変換されるので、複数クラスになる。
- https://qiita.com/ababup1192/items/213a47ab51aa361741b2#msg%E3%81%A8update
  - この記事がテスト駆動で書かれていてとても参考になる
- https://fonts.google.com/specimen/Signika?preview.text=01234567889&preview.text_type=custom&vfonly=true#standard-styles
  - font
## log
- 2020/11/04
  - appつくりはじめた
- 2020/11/05
  - 次はView部分の作り込みをする。見た目を決めたら必要なデータも決まってくるかなと。
  - message部分は

