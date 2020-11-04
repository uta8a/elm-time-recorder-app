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