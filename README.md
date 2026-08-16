# dsh-launcher

DeepSeek Harness (dsh) Web UI 一键启动脚本。

双击即可启动 `dsh web` 并自动打开浏览器：

- **Windows**：双击 `start-dsh.bat`（也可在 cmd 中运行 `start-dsh.bat [端口]`）
- **Linux / macOS**：`./start-dsh.sh [端口]`

## 特性

- 自动检测 Node.js，缺失时给出安装提示
- 自动选择启动方式：
  - 在 deepseek-harness 源码 checkout 内运行 → `pnpm dsh web`
  - 其他位置 → `npx --yes @deepseek-ai/dsh web`（自动安装/更新，无需手动 clone）
- 检测到服务已在运行 → 只打开浏览器，不重复启动
- 等待端口就绪后自动打开浏览器
- 支持自定义端口：`start-dsh.bat 8080` / `./start-dsh.sh 8080`

## 前置要求

- Node.js（≥ 18，https://nodejs.org/）
- 源码模式额外需要 `pnpm`；npx 模式需要能访问 npm registry

## 资源

- `assets/dsh-favicon.svg` — 官方 favicon 原图（来自 [deepseek-harness](https://github.com/deepseek-ai/deepseek-harness) 仓库 `apps/web/public/favicon.svg`，MIT 许可）
- `assets/dsh-favicon.ico` — 由 SVG 生成的桌面快捷方式图标（品牌鲸鱼蓝，含 16–256 多尺寸）

## 说明

- 默认端口 `3080`，即 `http://127.0.0.1:3080`
- Windows 下服务在独立的 "dsh web" 窗口运行，按 `Ctrl+C` 停止
- Linux/macOS 下日志写入 `dsh-launcher.log`，按 `Ctrl+C` 停止
- 项目处于开发者预览阶段，接口可能破坏性变更，请关注 [deepseek-harness](https://github.com/deepseek-ai/deepseek-harness) 上游

## License

MIT
