基於[CC BY-NC 4.0許可證](LICENSE)發佈。

## 魔龍

魔龍是基於[℞魔然](https://github.com/ksqsf/rime-moran)框架製作的，使用[℞自然龍](https://github.com/Elflare/rime-zrlong)的帶調韻母和形碼，並根據[℞冰雪拼音](https://github.com/hanzi-chai/rime-snow-pinyin)和[℞霧凇拼音](https://github.com/iDvel/rime-ice)的大詞庫進行了擴充的[Rime](https://rime.im/)輸入方案。

在魔龍的基礎上，另有兩套衍生方案，分別爲**環形鶴（环形鹤）**和**環形自然（环形自然）**。環形鶴和環形自然均爲基於雙拼的韻母分佈，通過【4聲-**1聲**-2聲-3聲】的平移規則，實現不同聲調韻母的方案。

各Release之間的區別請見下表。

| Release          | 音碼方案 | 形碼方案 | 簡繁   | 備考              |
| ---------------- | ---- | ---- | ---- | --------------- |
| `molong-chs`     | 自然龍  | 自然龍  | 簡體爲主 |                 |
| `molong-cht`     | 自然龍  | 自然龍  | 繁体爲主 |                 |
| `zrloopkai-chs`  | 環形自然 | 魔然   | 簡體爲主 |                 |
| `zrloopkai-cht`  | 環形自然 | 魔然   | 繁体爲主 |                 |
| `xhloopkai-chs`  | 環形鶴  | 魔然   | 簡體爲主 |                 |
| `xhloopkai-cht`  | 環形鶴  | 魔然   | 繁体爲主 |                 |
| `xhloopfly-chs`  | 環形鶴  | 小鶴雙形 | 簡體爲主 | 企劃中，小字庫，受限於小鶴雙形 |
| `xhloopfly-cht`  | 環形鶴  | 小鶴雙形 | 繁体爲主 | 企劃中，小字庫，受限於小鶴雙形 |
| `zrloopmoqi-chs` | 環形自然 | 墨奇碼  | 簡體爲主 | 企劃中             |
| `zrloopmoqi-cht` | 環形自然 | 墨奇碼  | 繁体爲主 | 企劃中             |
| `xhloopmoqi-chs` | 環形鶴  | 墨奇碼  | 簡體爲主 | 企劃中             |
| `xhloopmoqi-cht` | 環形鶴  | 墨奇碼  | 繁体爲主 | 企劃中             |


## 音碼方案
### 音碼選擇1：自然龍
![Molong_Page1](https://github.com/jack2game/rime-molong/assets/16070158/bc588c94-21cd-4868-99ac-1b459e9509e1)
### 音碼選擇2：環形鶴
![Molong_Page2](https://github.com/jack2game/rime-molong/assets/16070158/747a0c49-e4bf-4a69-92ac-941e97e2c763)
### 音碼選擇3：環形自然
![Molong_Page3](https://github.com/jack2game/rime-molong/assets/16070158/2c131c26-1d33-4d5c-87f3-2215c25b05d7)

**魔龍的所有音碼方案均完全兼容純雙拼打字法**，藉助於[℞冰雪拼音](https://github.com/hanzi-chai/rime-snow-pinyin)和[℞霧凇拼音](https://github.com/iDvel/rime-ice)的大詞庫，以及帶調韻母的優勢，魔龍的純雙拼模式的詞組重碼性能與傳統形碼（例如五筆）基本持平。
## 形碼方案
### 形码選擇1：自然龍
[℞自然龍](https://github.com/Elflare/rime-zrlong)的形碼方案是[Elflare](https://github.com/Elflare)在[℞魔然](https://github.com/ksqsf/rime-moran)形碼的基礎上修改而來，基本保持了自然碼的音托形碼的規則，同時具有重碼少、容錯低、離散高的特點，如有興趣可以前往[℞自然龍](https://github.com/Elflare/rime-zrlong)的項目倉庫做進一步的瞭解。
### 形码選擇2：魔然
![moran](https://github.com/jack2game/rime-molong/assets/16070158/5a870436-d4e6-4b2e-a69a-1d9927294222)
（Credit：@更漏子 製圖）

[℞魔然](https://github.com/ksqsf/rime-moran)形碼同樣保持了自然碼的音托形碼的規則，每個字的輔助碼只有兩個字母，取碼方式極爲簡單：
- **第一個字母** 取這個字的 **部首** 的雙拼首字母。
- **第二個字母** 取這個字 **除部首外的最大可識讀部件** 的雙拼首字母。

魔然形碼具有超大字庫、簡繁通用、易上手、容錯好的特點，如有興趣可以前往[℞魔然](https://github.com/ksqsf/rime-moran)的項目倉庫做進一步的瞭解。
### 形码選擇3：小鶴雙形
- 企劃中
### 形码選擇4：墨奇碼
- 企劃中


## 單字輸入方式

魔龍方案中，每個字的編碼是雙拼碼（記作 `YY`「音音」）疊加輔助碼（記作 `XX`「形形」）。因此，一個字的全碼是 `YYXX`。在魔龍方案中，一個字有下面幾種方式可以打出：

| 編碼      | 演示                                                                                                                           | 備考                                     |
| ------- | ---------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| `Y`     | <img src="https://github.com/jack2game/rime-molong/assets/16070158/c57f482a-261e-4390-ac57-83e1de3f9e21">                   |                                        |
| `YY`    | <img src="https://github.com/jack2game/rime-molong/assets/16070158/659635ef-dc0c-408c-b7a6-0786cb2eda9d"> |                                        |
| `YYX`   | <img src="https://github.com/jack2game/rime-molong/assets/16070158/8460d133-281d-48a0-8155-43908bee9dc6"> |                                        |
| `YYXX`  | <img src="https://github.com/jack2game/rime-molong/assets/16070158/6646ccb6-43ff-49a7-a8ad-724f3c9d3e2b"> | 結合優先級低⬇️，如果該編碼是合法的詞語編碼，則只顯示詞語候選項，不顯示單字 |
| `YYXX/` | <img src="https://github.com/jack2game/rime-molong/assets/16070158/2dd3ed1d-eb33-4dd3-8762-052e747598ba"> | 結合優先級高⬆️，一般會在詞語的前面                     |

其中，帶有「⚡️」圖標的輸出爲固定簡碼。單字簡快碼只在輸入碼長小於等於 3 時起效。

在完全熟悉簡快碼後，可以參考`molong.schema.yaml`中的說明取消或更換「⚡️」圖標。


## 整句輸入、與輔助碼造詞
魔龍方案允許你**將輔助碼與整句雙拼混合**在一起輸入。

<img src="https://github.com/jack2game/rime-molong/assets/16070158/91411509-6d80-4b1c-9042-ed268960aacb">

如果打完了第二個字回頭發現第一個字需要輔助碼，可**按 tab 鍵**快速在音節間跳轉。

在用輔助碼打出一個詞後，這個詞會被自動記憶，以後可不加輔助碼打出。

要刪除所造詞，可移動高亮條目到待刪除之詞，然後按下 `Ctrl+Delete` （Windows、Linux）或 `Shift+Fn+Delete`（macOS）。


## 反查功能
魔龍方案具有多種反查方式：
- 通配符反查：輸入音碼後按 `` ` ``
- 虎碼反查：用 `` ` `` 引導
- 倉頡反查：用 ``ocj`` 引導
- 筆畫反查：用 ``obh`` 引導
- 兩分反查：用 ``olf`` 引導（注：鶴系列方案使用小鶴雙拼，其他方案使用自然雙拼）
- 拆字反查：用 ``ocz`` 引導（注：各方案使用各自對應的雙拼）

（在反查時，上述前綴會被隱藏，避免干擾視線。）

| 反查方式  | 演示                                                                                                        |
| ----- | --------------------------------------------------------------------------------------------------------- |
| 通配符反查 | <img src="https://github.com/jack2game/rime-molong/assets/16070158/73c5fc63-7ad8-4fcc-8f18-c6aceb65b530"> |
| 虎碼反查  | <img src="https://github.com/jack2game/rime-molong/assets/16070158/fa6ee644-c451-472b-a4cf-4200d9686f49"> |
| 倉頡反查  | <img src="https://github.com/jack2game/rime-molong/assets/16070158/1f58295e-37f9-4f27-8ce1-401e5e7cc00f"> |
| 筆畫反查  | <img src="https://github.com/jack2game/rime-molong/assets/16070158/b8832cb7-f965-4434-9701-84819f904f87"> |
| 兩分反查  | <img src="https://github.com/jack2game/rime-molong/assets/16070158/398a0b1f-ec03-4ec9-8f65-54858a3475b8"> |
| 拆字反查  | <img src="https://github.com/jack2game/rime-molong/assets/16070158/a6eed195-4b1d-4596-bdd9-7bb96f98cdb1"> |


## 相關鏈接
[℞魔然](https://github.com/ksqsf/rime-moran)  [℞自然龍](https://github.com/Elflare/rime-zrlong)  [℞冰雪拼音](https://github.com/hanzi-chai/rime-snow-pinyin)  [℞霧凇拼音](https://github.com/iDvel/rime-ice)  [℞墨奇音形](https://github.com/gaboolic/rime-shuangpin-fuzhuma)

[💬魔龍以及環形系列討論區](https://github.com/jack2game/rime-molong/discussions)  [💬龍碼音形討論組](https://qm.qq.com/q/HMnh5u93Ik)  [💬魔然討論組](https://qm.qq.com/q/XdQPaf3fSq)


## License
This project, [rime-molong](https://github.com/jack2game/rime-molong), is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License. You can view the full license [here](LICENSE). [rime-molong](https://github.com/jack2game/rime-molong) is based on [rime-moran](https://github.com/ksqsf/rime-moran) by [ksqsf](https://github.com/ksqsf). Changes were made to the original project.

[rime-molong](https://github.com/jack2game/rime-molong)方案根據Creative Commons Attribution-NonCommercial 4.0 International許可證發佈。您可以在[此處](LICENSE)查看完整的許可證。[rime-molong](https://github.com/jack2game/rime-molong)依據基於[ksqsf](https://github.com/ksqsf)的[rime-moran](https://github.com/ksqsf/rime-moran)方案修改製作。
