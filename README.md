# ElmTodoTimeApp
- https://uta8a.github.io/elm-time-recorder-app/ から見ることができます。作りかけです。

```
PUBLIC_URL="https://uta8a.github.io/elm-time-recorder-app/" elm-app build
cp -r build docs # GitHub pages
```
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
  - fontはLicenseに気をつける
- maybeという概念が出てきた。Optionみたいなものかな。
- GitHub Pagesに反映されないけどこれのせいか？ `PUBLIC_URL=./ elm-app build` https://github.com/halfzebra/create-elm-app/blob/master/template/README.md
- JSONを2つマージするときのデータの整合性はどうしようか。最後に編集したときを考えていたけど、これはファイル名からいけるので、いらないかも。(JSONマージするときに大きい方をとるか、合計するか選択できるといいね)
- dataの持ち方が難しい。Durationも使えなさそう。Time.Posixで持っておいて、Intに直してhour, minute, secを取り出す方針で行きたい。(自前でやる)
  - なんか便利があり解決 posixtomillisみたいなやつ
- localStrageに毎秒記録する方針で行きたい
- flags -> Date.now() -> これはIntなのでstart timeはIntとして処理されている
- viewでlet inできるみたいなのでcomponentっぽくできそう。
- findAllが0を返すんだけど...
```
▼ Query.findAll [ attribute "id" "main" ]

0 matches found for this query.
```
- `findAll [id "xxx"]` すると0を返す？
- Elmでcontenteditableなtext-boxを作るのは難しそう？ https://stackoverflow.com/questions/58949541/elm-oninput-event-handler-not-working-on-contenteditable-element
- 時間との兼ね合いから、今回はUpdateをなしにする。
- NewTodo 引数 title
- どうもつらいと思ったらDOM周りの関数がExposeされていないのかな？ https://stackoverflow.com/questions/62819593/get-elements-by-class-name-with-elm-browser-dom

## log
- 2020/11/04
  - appつくりはじめた
- 2020/11/05
  - 次はView部分の作り込みをする。見た目を決めたら必要なデータも決まってくるかなと。
  - Viewのdisplay-time部分を作っている
  - まだできてないけどCSS的にはいい感じ(仮組みとしては上々)
  - 次はtodo部分の見た目CSSを作る
  - tailwindで吐き出したCSS、GitHub Pagesで必要だから入れたけど2.3MBもあって草
    - minifyを使う
  - durationやばそうなので、Todos周りをいい感じにしてからdurationにとりかかろう
  - どんどん複雑になってきてやばいので、このへんで休憩して明日課題終えたらまたやってみる。
  - text inputがマジでわからなくて困る。挙動が怪しい。
- 2020/11/06
  - 今日で完成させたいけどinputの挙動分からなさすぎる
- 2020/11/07
  - 昨日は進捗報告回だったので完成できなかった。
  - todoのadd/deleteを実装した。すごく頭悪い方法だけど...(DOMベースの思考でやっていたけど、Elmだとデータ基本で考えるので自分の頭の悪さを自覚してトレーニングになる気がする)