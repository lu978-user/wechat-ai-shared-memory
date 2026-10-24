# 安装

> **安全提示：** 示例 systemd 单元默认使用 `User=root` 以匹配已验证的原型。不要未经审查直接用于多用户或公网主机；优先使用专用低权限服务账户，并同步调整文件所有权、Hook 运行身份与恢复权限。local API 必须只监听回环地址。

## 1. 准备环境
Linux 主机、systemd、网络访问和适用于目标平台的第三方 `wx-bot`。本仓库不分发该二进制。

## 2. 获取并校验 wx-bot
从上游发布页下载适合平台的文件，并使用上游发布的 SHA-256 校验和核对。校验和只能验证下载文件与发布清单一致，不能证明上游代码本身可信。核实许可证后再使用。

## 3. 配置
```sh
mkdir -p ~/.config/wx-bot ~/.local/bin
chmod 700 ~/.config/wx-bot
cp config/config.example.json ~/.config/wx-bot/config.json
chmod 600 ~/.config/wx-bot/config.json
```
按 [配置说明](configuration.md) 设置真实白名单、随机本地 API token 和目录。真实配置不得进入仓库。

## 4. 登录
按上游工具的当前帮助完成扫码登录；具体命令以安装版本文档为准。登录态不得共享或提交。

## 5. systemd
审查并编辑 `config/wx-bot.service.example`，将占位路径替换为真实路径，审查运行用户与权限后再安装。不要盲目复制模板执行。安装后运行 `systemctl daemon-reload`、`systemctl enable --now wx-bot` 并检查服务状态。

## 6. Muse Hook
`scripts/wechat-hook.sh` 依赖 Muse Hook 运行时提供的 `HATCH_HOOK_RUNTIME` 及 `log/wake/silent` 函数。它不是独立脚本；接入前先阅读代码、在 dry-run 模式验证，并按平台规则设置轮询周期。