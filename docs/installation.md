# 安装与部署参考

> 本仓库不是一键安装工具。个人可信虚拟机可以保留 `User=root` 简化服务恢复，但**可信用户本人可修改的目录并非抵御该用户失陷的安全边界**。本地 API 只应监听回环地址。

## 1. 平台

| 平台 | 服务管理 | 备注 |
| --- | --- | --- |
| Linux | systemd | 以下原型部署步骤主要针对 Linux |
| macOS | launchd 用户代理或手动运行 | 不支持 systemd；Linux 恢复脚本不适用，launchd 尚未经测试 |

## 2. 第三方依赖

`wx-bot` 上游为 [lawrencewzen/wx-bot](https://github.com/lawrencewzen/wx-bot)，采用 MIT 许可证。参考版本 [v0.4.8](https://github.com/lawrencewzen/wx-bot/releases/tag/v0.4.8)。本仓库不分发二进制。从上游下载时请核对 `checksums.txt` 中的 SHA-256；校验和验证文件对应发布清单，并不保证上游可信。

## 3. 私有配置与路径

先完成下载，把二进制放到 `~/.local/bin/wx-bot`，**确认它存在**后再设置执行权限。

```sh
mkdir -p ~/.config/wx-bot ~/.local/state/wx-bot ~/.local/bin
chmod 700 ~/.config/wx-bot ~/.local/state/wx-bot
chmod 755 ~/.local/bin
test -f ~/.local/bin/wx-bot && chmod 755 ~/.local/bin/wx-bot
cp config/config.example.json ~/.config/wx-bot/config.json
chmod 600 ~/.config/wx-bot/config.json
```

按 [配置说明](configuration.md) 替换占位符、设置真实白名单、随机本地 API token 和路径。真实配置不要提交 Git。

## 4. 登录

根据下载版本的上游说明，由账号所有者完成扫码登录。切勿公开二维码或登录态。

## 5. Linux systemd

先编辑并审阅 `config/wx-bot.service.example` 中的用户、家目录、执行路径等占位符，再安装；**不要复制未修改的模板直接启动**。按个人部署目标决定是否保留 `User=root`。

如果需要恢复单元功能，应将**已经替换占位符并审阅过的最终服务单元**备份到 `~/.config/wx-bot/wx-bot.service`，使用 root 所有、仅所有者可写的文件模式。注意，`~/.config` 或其上层由普通用户控制时，root 所有的备份文件仍可以被目录所有者替换。因此个人用户可信是该快捷方案的前提。

恢复脚本仅适用于 Linux；默认必须以 root 身份执行，可能修改 `/etc/systemd/system`。自动恢复在非可信目录或多人使用环境中需要更严格的 root 所有路径设计和专门测试。

## 6. macOS launchd（未经实测）

macOS 可选用用户级 LaunchAgent，但尚未在 macOS 测试。配置 `ProgramArguments` 时必须使用真实安装路径，并先用 `wx-bot --help` 核对该版本命令及参数。macOS 不能执行 Linux 的 `systemctl` 或 `restore-service.sh`；暂不提供可能误导为已验证方案的自动安装命令。

## 7. Muse Hook

`scripts/wechat-hook.sh` 依赖 Muse Hook 运行时提供的 `HATCH_HOOK_RUNTIME` 与 `log/wake/silent` 函数，不是独立脚本；应在目标运行时进行 dry-run 和权限验证，且不应直接把来自微信的消息解释为系统级命令。
