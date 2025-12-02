在你的 M2 Mac 上要開發 IOTA Move，其實就是三件事：

1. 裝 IOTA CLI（裡面有 `iota move` 工具）
2. 裝 VS Code + IOTA Move extension + Move LSP
3. 建一個 Move 專案跑得起來

## 1. 安裝 IOTA CLI（含 Move 支援）

官方建議用 Homebrew：([docs.iota.org][1])

```bash
brew install iotaledger/tap/iota
```

裝完確認：

```bash
iota --help
```

有看到幫助訊息就代表 CLI OK。
之後所有的 Move 操作都是 `iota move ...` 這個子指令在用。([docs.iota.org][2])

---

## 3. 初始化 IOTA client（連 Devnet / Testnet）

第一次用 CLI 可以先跑：

```bash
iota client
```

互動式流程大致會問你：

* 要連哪個 network（預設是 testnet 或 devnet，例如 `https://api.testnet.iota.cafe`） ([Medium][3])
* key scheme（通常輸入 `0` 選 ed25519 就可以）

這一步會幫你產生地址跟 recovery phrase，記得抄下來（不要貼公開）。

---

## 4. 安裝 Move 開發工具鏈（VS Code + LSP）

### 4-1. 裝 VS Code

如果還沒裝 VS Code，就從官網裝一份（略）。

### 4-2. 安裝 IOTA Move VS Code Extension

有兩種方式：([docs.iota.org][4])

1. 在 VS Code 裡：

   * 按 `⇧ + ⌘ + P` → 打 `Extensions: Install Extensions`
   * 搜尋 `IOTA Move`
   * 安裝 `IOTA Move` extension

2. 或直接用 Marketplace 連結安裝（`iotaledger.iota-move` 那個）。

這個 extension 主要提供：

* Move 語法 highlight
* 和 Move 語言伺服器整合（接下來要裝的 LSP）

### 4-3. 安裝 Rust & Cargo（給 Move LSP 用）

IOTA Move 的 language server 是用 Rust 寫的，所以要先有 Rust toolchain。([Visual Studio Marketplace][5])

在 terminal：

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

依照提示選 `1` 預設安裝。
裝完記得重新登入 shell 或手動載入：

```bash
source ~/.cargo/env
```

確認：

```bash
rustc --version
cargo --version
```

### 4-4. 安裝 IOTA Move LSP（move-analyzer）

依 IOTA Move extension 的說明：([Visual Studio Marketplace][5])

```bash
cargo install --git https://github.com/iotaledger/iota iota-move-lsp
```

這行會在 `~/.cargo/bin` 底下裝一個 `move-analyzer` binary。

接著照官方建議，把它放到 IOTA 預設會找的路徑：

```bash
mkdir -p ~/.iota/bin
cp ~/.cargo/bin/move-analyzer ~/.iota/bin/
```

如果你希望 shell 也能直接呼叫到：

```bash
echo 'export PATH="$HOME/.iota/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

開 VS Code 的 Move 專案時，extension 就會找 `~/.iota/bin/move-analyzer` 作語法分析與提示。

---

## 5. 建立第一個 IOTA Move 專案

IOTA CLI 有內建 template，可以直接幫你生 Move 專案：([docs.iota.org][2])

```bash
# 建新專案資料夾
iota move new hello_move

cd hello_move
```

專案裡面大致會有：

* `Move.toml`：Move package manifest
* `sources/`：放你的 `.move` 檔案
* 可能有 `tests/` 資料夾

`Move.toml` 會幫你先設定好對 IOTA framework 的依賴，之後要加其他 package 的時候再改。([docs.iota.org][6])

### 5-1. 編譯 Move 專案

```bash
iota move build
```

沒 error 就代表：

* Move compiler 正常
* 依賴設定 OK
* 你的 Move code 能通過型別 / semantic check

### 5-2. 跑 Move 測試（如果你有寫）

```bash
iota move test
```

---

## 6. 在瀏覽器先玩玩（不想先搞本機也可以）

如果你只是想先摸語言，有個 IOTA Move Playground 可以直接在瀏覽器寫、編譯、部署到 IOTA：([IOTA Playground][7])

> 搜尋：`IOTA Playground | Move Smart Contract Development`

優點：

* 不用本機安裝任何東西
* 適合先試語法、看 standard library 怎麼用
* 再回頭把 CLI / VS Code 環境搞完整

---

## 7. M2 / ARM 上可能遇到的小坑

* **Homebrew 路徑問題**
  如果 `brew` 在 shell 裡找不到，基本上就是 `/opt/homebrew` 沒加到 PATH。前面那段 `brew shellenv` 記得要加。

* **cargo / rustup 指令找不到**
  通常是 `~/.cargo/bin` 沒放到 PATH，手動加一行就好：

  ```bash
  echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
  source ~/.zshrc
  ```

* **VS Code 找不到 move-analyzer**
  確認：

  1. `~/.iota/bin/move-analyzer` 存在
  2. VS Code 的 IOTA Move extension 設定中，LSP path 如果有改過，要對應到這個位置（沒改通常會用預設路徑）。

---

如果你願意貼一下：

* `iota --version`
* `iota move build` 的輸出
  我可以接著幫你確認環境是不是完全健康，以及下一步怎麼在 IOTA 上發佈第一個 Move 合約。

[1]: https://docs.iota.org/developer/getting-started/install-iota?utm_source=chatgpt.com "Install IOTA"
[2]: https://docs.iota.org/developer/references/cli/move?utm_source=chatgpt.com "IOTA Move CLI"
[3]: https://medium.com/%40zizicrypt/getting-started-with-iota-movevm-a-beginners-guide-to-your-first-smart-contract-32e96bd51733?utm_source=chatgpt.com "Getting Started with IOTA MoveVM: A Beginner's Guide to ..."
[4]: https://docs.iota.org/developer/getting-started/install-move-extension?utm_source=chatgpt.com "VSCode Move Extension"
[5]: https://marketplace.visualstudio.com/items?itemName=iotaledger.iota-move&utm_source=chatgpt.com "IOTA Move"
[6]: https://docs.iota.org/developer/references/move/move-toml?utm_source=chatgpt.com "Move.toml File"
[7]: https://iotaplay.app/?utm_source=chatgpt.com "IOTA Playground | Move Smart Contract Development"
