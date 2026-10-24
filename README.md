# 微信 AI 接入 + 跨 AI 共享记忆

将微信消息桥接到 AI 助手，并通过用户授权的共享文档保存跨助手协作记忆的部署参考项目。

> **状态：原型配置与文档公开中，非一键安装成品。** 微信收发与共享文档读写曾在维护者的私有环境中验证；干净主机上的端到端复现尚未完成。本仓库不包含 Muse 运行时或独立 Agent 实现。

## 包含内容
- `scripts/wechat-hook.sh`：依赖 Muse Hook 运行时的 pull 收件箱轮询适配器。
- `scripts/restore-service.sh`：恢复 systemd 单元的辅助脚本。
- `config/*.example`：不含真实凭证的示例配置。
- `docs/`：安装、配置、架构、故障排查与共享记忆协议。
- `examples/`：晨报与周复盘的任务规范示例。
- `tests/`：示例配置与公开树安全检查。

## 快速了解
1. 阅读 [安装说明](docs/installation.md) 与 [配置说明](docs/configuration.md)。
2. 阅读 [共享记忆协议](docs/shared-memory.md)。
3. 发布前运行：
   `bash tests/test_config_example.sh && bash tests/test_audit.sh`

## 安全与限制
- 本仓库不分发第三方 `wx-bot` 二进制；用户需自行确认上游来源与许可证并验证 SHA-256。
- Hook 依赖 Muse 提供的运行时变量和函数，不是通用独立程序。
- 示例 systemd 单元保留原型环境的 `User=root`，仅用于说明已验证环境；部署前应评估专用低权限服务账户并调整权限和恢复流程。
- 不得提交微信登录态、Token、API Key、OAuth 凭据、真实用户标识、私有文档内容或日志。
- 共享文档是经授权的外部记忆源，不会让不同 AI 产品的内置记忆自动实时同步。

## 许可证
许可证尚未定稿，因此当前版本不附授予再分发权利的许可证文件。请勿将仓库公开可见误认为已授予开源许可。维护者确认著作权人及许可证后再补充正式 LICENSE。
