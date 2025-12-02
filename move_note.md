# Move 語言開發

水龍頭

```
iota client faucet
```

起專案

```
iota move new <package_name>
```

語法：https://move-book.com/

## Object

- Own Object - 特定
- Share Object - 大家共用

## Struct

語法

```
<T> -> 泛型
```

可以讓你的 struct 做更高度的抽象化

### Ability

- key - UUID
- store - 可儲存在任何物件、可被轉移
- drop - 可被丟棄 GC 掉
    - https://move-book.com/move-basics/drop-ability
    - 當擁有這個屬性，當被轉移後會被 GC 掉，但物件本身不應該擁有
- copy - 可被複製


不是所有 Ability 可以同時擁有
擁有 key 不能有 drop 或 copy
因為他是唯一值，且不可被丟棄，因此 key 通常會跟 store 一起

常見的組合
event -> copy, drop

而幾本型別幾乎都存在 copy, drop, store

```move
public struct String has copy, drop, store {
    bytes: vector<u8>,
}
```


## Witness & OTW

### Witness

很少用且一定要 drop，可以比喻成印章

### One-Time Witness

只能蓋一次後就再也不能蓋章，例如 package_name

限制：
- 名字一定要跟 module name 一模一樣
- 全大寫
- 不能有任何內容


## Function

### Vidibolity

沒填預設只能在 module 內使用

- entry - 只有 frontend - sdk 使用時
- public - 誰都能使用
- public(package)

### Type

```
<T>
```

### init

package 發布時一次性執行完後就不會在執行過了

### Ownership

- Type -> 給予後就給他了
- &Type -> 給予後有指標指著，能夠跟他說屬性...
- &mut Type -> 可 mut


所以當使用 Function 時的 Arg 

-  &Type 時 return 只能是 &Type
- Type 進去可以回傳 &Type, &mut Type
- &mut Type 進去可以回傳 &Type, &mut Type

因此可以理解 Type 為最高層級

## Coin

### Treasury Cap

Capability

這個用來做權限管理


以一個販賣機(vendor machine)來當範例

machine 本身應該是 public 的
放置在機器內的商品為 share 的，因為可轉移
而放錢的小金庫則需要具備 Capability

收的錢一定是你能放，因此 arg 會是 Type
小金顧取錢 func 會是 public，且 arg 帶入機器（& or &mut）並且帶入鑰匙(cap)


