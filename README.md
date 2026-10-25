# 微信 AI 接入 + 跨 AI 共享记忆

微信消息桥接与跨助手共享记忆的部署参考项目。

> **状态：原型部署胶水与文档，尚非一键安装成品。** 微信消息收发与共享文档读写曾在维护者的私有环境验证；干净主机上的完整端到端复现尚未完成。本仓库不包含 Muse 运行时或独立 Agent 推理代码。

## 内容
- `scripts/restore-service.sh`：恢复 systemd 单元的辅助脚本。
- `scripts/wechat-hook.sh`：依赖 Muse Hook 运行时的微信收件箱轮询适配器。
- `scripts/audit-public-tree.sh`：公开目录安全检查脚本。
- `config/`：桥接配置与 systemd 示例模板。
- `docs/`：安装、配置、架构、共享记忆与故障排查说明。
- `examples/`：晨报与每周复盘任务规范。
- `tests/`：冒烟测试。

## 限制
本仓库不包含第三方 `wx-bot` 二进制、Muse 运行时、生产配置、凭证、运行数据或私人共享记忆。Hook 不是独立程序，必须适配 Muse Hook 运行时。

示例 systemd 单元保留原型中的 `User=root`，便于个人隔离虚拟机快速部署与恢复。这是便利性取舍，意味着服务具有较高权限。仅在可信环境使用，保护配置与脚本权限，local API 只监听回环地址，并限制微信白名单。

第三方依赖：`wx-bot` 上游是 https://github.com/lawrencewzen/wx-bot（MIT 许可证），本项目记录的参考版本是 [v0.4.8](https://github.com/lawrencewzen/wx-bot/releases/tag/v0.4.8)。本仓库不打包第三方二进制；自行下载时应核对官方发布资产与 SHA-256 校验和。

## 测试
运行 `bash tests/test_config_example.sh` 和 `bash tests/test_audit.sh`。安全审计仅覆盖常见模式，不能替代人工检查。

## 许可证
维护者原创且有权授权的脚本、文档、模板与示例采用 [MIT License](LICENSE)。第三方 `wx-bot`、Muse 运行时与 Google Workspace 连接器各自遵循其上游或平台条款。
