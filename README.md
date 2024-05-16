基於[CC BY-NC 4.0許可證](LICENSE)發佈。

## 魔龍

魔龍是基於[℞魔然](https://github.com/ksqsf/rime-moran)框架製作的，使用[℞自然龍](https://github.com/Elflare/rime-zrlong)的帶調韻母和形碼，並根據[℞冰雪拼音](https://github.com/hanzi-chai/rime-snow-pinyin)和[℞霧凇拼音](https://github.com/iDvel/rime-ice)的大詞庫進行了擴充的[Rime](https://rime.im/)輸入方案。

在魔龍的基礎上，另有兩套衍生音碼方案，分別爲 **環形鶴（环形鹤）** 和 **環形自然（环形自然）** 。環形鶴和環形自然均爲基於雙拼的韻母分佈，通過【4聲-**1聲**-2聲-3聲】的平移規則，實現不同聲調韻母的方案。

各[發佈版本](https://github.com/jack2game/rime-molong/releases)之間的區別請見下表。含有`-chs`後綴的方案是簡體爲主、可以打出繁體字的方案；含有`-cht`後綴方案則相反，在此不再重複。

| Release      | 音碼方案 | 形碼方案 | 單字數量  | 備考          |
| ------------ | ---- | ---- | ----- | ----------- |
| `molong`     | 自然龍  | 自然龍  | 4.7萬+ |             |
| `molong`     | 自然龍  | 魔然   | 4.9萬+ | 企劃中         |
| `xhloopkai`  | 環形鶴  | 魔然   | 4.9萬+ |             |
| `zrloopkai`  | 環形自然 | 魔然   | 4.9萬+ |             |
| `xhloopfly`  | 環形鶴  | 小鶴雙形 | <1萬   | 小字庫，受限於小鶴雙形 |
| `molongmoqi` | 自然龍  | 墨奇碼  |       | 企劃中         |
| `xhloopmoqi` | 環形鶴  | 墨奇碼  |       | 企劃中         |
| `zrloopmoqi` | 環形自然 | 墨奇碼  |       | 企劃中         |


## 音碼方案
### ❶自然龍音碼
![Molong_Page1](https://github.com/jack2game/rime-molong/assets/16070158/bc588c94-21cd-4868-99ac-1b459e9509e1)

### ❷環形鶴音碼
![Molong_Page2](https://github.com/jack2game/rime-molong/assets/16070158/747a0c49-e4bf-4a69-92ac-941e97e2c763)
基於現有的雙拼韻母位置，定位相應韻母的1聲，接下來根據【4-1-2-3】的規則平移，就可以找到2聲3聲4聲。例如：
- `ke = ke1` `kr = ke2` `kt = ke3` `kw = ke4`

如果平移的過程中超過鍵盤左側或右側按鍵的邊界，則做環形移動：
- `ha = ha1` `hs = ha2` `hk = ha3` `hl = ha4`

與龍碼的亂序帶調方案對應，環形是有規律的帶調韻母方案。

### ❸環形自然音碼
![Molong_Page3](https://github.com/jack2game/rime-molong/assets/16070158/2c131c26-1d33-4d5c-87f3-2215c25b05d7)

**魔龍的所有版本均完全兼容純音碼打字法**，藉助於[℞冰雪拼音](https://github.com/hanzi-chai/rime-snow-pinyin)和[℞霧凇拼音](https://github.com/iDvel/rime-ice)的大詞庫，以及帶調韻母的優勢，魔龍的純音碼模式的詞組重碼性能與傳統形碼（例如五筆）基本持平。
## 形碼方案
### ❶自然龍形码
<details>

<summary>字根圖</summary>

![moran](https://github.com/jack2game/rime-molong/assets/16070158/5a870436-d4e6-4b2e-a69a-1d9927294222)
（Credit：@更漏子 製圖）

</details>

[℞自然龍](https://github.com/Elflare/rime-zrlong)的形碼方案是[Elflare](https://github.com/Elflare)在[℞魔然](https://github.com/ksqsf/rime-moran)形碼的基礎上修改而來，字根歸併和取碼與魔然相同，只是個別單字的拆字方式稍有差異，同時具有重碼少、容錯低、離散高的特點，如有興趣可以前往[℞自然龍](https://github.com/Elflare/rime-zrlong)的項目倉庫做進一步的瞭解。

### ❷魔然形码
<details>

<summary>字根圖</summary>

![moran](https://github.com/jack2game/rime-molong/assets/16070158/5a870436-d4e6-4b2e-a69a-1d9927294222)
（Credit：@更漏子 製圖）

</details>

[℞魔然](https://github.com/ksqsf/rime-moran)形碼同樣保持了自然碼的音托形碼的規則，每個字的輔助碼只有兩個字母，取碼方式極爲簡單：
- **第一個字母** 取這個字的 **部首** 的音碼首字母。
- **第二個字母** 取這個字 **除部首外的最大可識讀部件** 的音碼首字母。

魔然形碼具有超大字庫、簡繁通用、易上手、容錯好的特點，如有興趣可以前往[℞魔然](https://github.com/ksqsf/rime-moran)的項目倉庫做進一步的瞭解。

### ❸小鶴形碼

<details>

<summary>字根圖</summary>

![xhzg](https://github.com/jack2game/rime-molong/assets/16070158/c48aaa4d-fa3d-4ff8-83dd-663d18e8781d)

</details>

基於小鶴雙形的形碼方案，如有興趣可以前往[小鶴官方網站](https://flypy.cc/#/ux)做進一步的瞭解。

### ❹墨奇形码

<details>

<summary>字根圖</summary>

![Molong_Page4](https://github.com/jack2game/rime-molong/assets/16070158/63572000-632b-4511-8159-406776853e3b)

</details>

基於墨奇碼的形碼方案，同樣保持了音托形碼的規律，具有順序拆字、字根易讀、重碼較少的特點，如有興趣可以前往[℞墨奇碼](https://github.com/gaboolic/rime-shuangpin-fuzhuma/wiki/%E5%A2%A8%E5%A5%87%E7%A0%81%E6%8B%86%E5%88%86%E8%A7%84%E5%88%99)的項目倉庫做進一步的瞭解。


## 單字輸入方式

魔龍方案中，每個字的編碼是音碼（記作 `YY`「音音」）疊加形碼（記作 `XX`「形形」）。因此，一個字的全碼是 `YYXX`。在魔龍方案中，一個字有下面幾種方式可以打出：

| 編碼      | 演示                                                                                                        | 備考                                     |
| ------- | --------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| `Y`     | <img src="https://github.com/jack2game/rime-molong/assets/16070158/c57f482a-261e-4390-ac57-83e1de3f9e21"> |                                        |
| `YY`    | <img src="https://github.com/jack2game/rime-molong/assets/16070158/659635ef-dc0c-408c-b7a6-0786cb2eda9d"> |                                        |
| `YYX`   | <img src="https://github.com/jack2game/rime-molong/assets/16070158/8460d133-281d-48a0-8155-43908bee9dc6"> |                                        |
| `YYXX`  | <img src="https://github.com/jack2game/rime-molong/assets/16070158/6646ccb6-43ff-49a7-a8ad-724f3c9d3e2b"> | 結合優先級低⬇️，如果該編碼是合法的詞語編碼，則只顯示詞語候選項，不顯示單字 |
| `YYXX/` | <img src="https://github.com/jack2game/rime-molong/assets/16070158/2dd3ed1d-eb33-4dd3-8762-052e747598ba"> | 結合優先級高⬆️，一般會在詞語的前面                     |

其中，帶有「⚡️」圖標的輸出爲固定簡碼。單字簡快碼只在輸入碼長小於等於 3 時起效。

在完全熟悉簡快碼後，可以參考`molong.schema.yaml`中的說明取消或更換「⚡️」圖標。


## 整句輸入、與輔助碼造詞
魔龍方案允許你**將輔助碼與整句音碼混合**在一起輸入。

<img src="https://github.com/jack2game/rime-molong/assets/16070158/42465986-7691-48f1-be0e-b6a64aff797e">

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
- 拆字反查：用 ``ocz`` 引導（注：各方案使用各自對應的音碼）

（在反查時，上述前綴會被隱藏，避免干擾視線。）

| 反查方式  | 演示                                                                                                        |
| ----- | --------------------------------------------------------------------------------------------------------- |
| 通配符反查 | <img src="https://github.com/jack2game/rime-molong/assets/16070158/73c5fc63-7ad8-4fcc-8f18-c6aceb65b530"> |
| 虎碼反查  | <img src="https://github.com/jack2game/rime-molong/assets/16070158/fa6ee644-c451-472b-a4cf-4200d9686f49"> |
| 倉頡反查  | <img src="https://github.com/jack2game/rime-molong/assets/16070158/1f58295e-37f9-4f27-8ce1-401e5e7cc00f"> |
| 筆畫反查  | <img src="https://github.com/jack2game/rime-molong/assets/16070158/b8832cb7-f965-4434-9701-84819f904f87"> |
| 兩分反查  | <img src="https://github.com/jack2game/rime-molong/assets/16070158/398a0b1f-ec03-4ec9-8f65-54858a3475b8"> |
| 拆字反查  | <img src="https://github.com/jack2game/rime-molong/assets/16070158/a6eed195-4b1d-4596-bdd9-7bb96f98cdb1"> |

## 增補功能

| 功能說明      | 演示                                                                                                        | 備考                                                                                                  |
| --------- | --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| 當前日期      | <img src="https://github.com/jack2game/rime-molong/assets/16070158/d46dc050-99d7-4894-ba84-d7ad480f52f3"> |                                                                                                     |
| 當前節氣      | <img src="https://github.com/jack2game/rime-molong/assets/16070158/e816eea4-ad71-454c-a6cd-10568375584c"> |                                                                                                     |
| 當前星期      | <img src="https://github.com/jack2game/rime-molong/assets/16070158/a965c249-3e1b-4b75-aada-a7573a6110ea"> |                                                                                                     |
| 當前時間      | <img src="https://github.com/jack2game/rime-molong/assets/16070158/e6c4a829-84d2-45df-a5b5-7f6bc86a0154"> |                                                                                                     |
| 數字轉大寫     | <img src="https://github.com/jack2game/rime-molong/assets/16070158/2861499d-1b52-4172-993f-ea48948c8e0d"> |                                                                                                     |
| `/`引導輸入符號 | <img src="https://github.com/jack2game/rime-molong/assets/16070158/aa2548a3-9ec2-4c2d-9288-97428392e846"> | [symbols.yaml](https://github.com/jack2game/rime-molong/blob/main/molong-chs/symbols.yaml)查看更多符號 |

## 相關鏈接
[℞魔然](https://github.com/ksqsf/rime-moran)  [℞自然龍](https://github.com/Elflare/rime-zrlong)  [℞冰雪拼音](https://github.com/hanzi-chai/rime-snow-pinyin)  [℞霧凇拼音](https://github.com/iDvel/rime-ice)  [℞墨奇音形](https://github.com/gaboolic/rime-shuangpin-fuzhuma)

[💬魔龍以及環形系列討論區](https://github.com/jack2game/rime-molong/discussions)  [💬龍碼音形討論組](https://qm.qq.com/q/HMnh5u93Ik)  [💬魔然討論組](https://qm.qq.com/q/XdQPaf3fSq)


## License
This project, [rime-molong](https://github.com/jack2game/rime-molong), is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License. You can view the full license [here](LICENSE). [rime-molong](https://github.com/jack2game/rime-molong) is based on [rime-moran](https://github.com/ksqsf/rime-moran) by [ksqsf](https://github.com/ksqsf). Changes were made to the original project.

[rime-molong](https://github.com/jack2game/rime-molong)方案根據Creative Commons Attribution-NonCommercial 4.0 International許可證發佈。您可以在[此處](LICENSE)查看完整的許可證。[rime-molong](https://github.com/jack2game/rime-molong)依據基於[ksqsf](https://github.com/ksqsf)的[rime-moran](https://github.com/ksqsf/rime-moran)方案修改製作。
