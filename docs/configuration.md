# 配置

模板位于 `config/config.example.json`。复制到私有配置目录后再编辑，不要提交真实配置。

| 字段 | 用途 | 安全要求 |
| --- | --- | --- |
| `state_dir` | 收件箱与状态 | 仅本地存储，限制目录权限 |
| `media_dir` | 媒体文件 | 不公开、不提交 |
| `local_api.listen` | 本地 API 监听地址 | 仅回环地址，不暴露公网 |
| `local_api.token` | 本地 API 认证 | 使用随机值，文件权限 0600 |
| `bindings[].name` | 绑定名 | 例如 muse |
| `bindings[].delivery` | 消息投递模式 | pull 表示由 Agent 侧拉取 |
| `bindings[].allow_wxids` | 微信来源白名单 | 仅放入明确授权的用户标识 |

## 代理
如运行环境需要代理，可参考 `.env.example`。真实代理 URL 可能含用户名和密码；真实 env 文件需限制为 0600，绝不可提交。

## 最小安全基线
- 配置目录权限 0700，凭证文件权限 0600。
- 只允许必要的微信用户触发任务。
- 不要公开 local API、登录态、收件箱或日志。
- 示例 systemd 文件以 root 运行是原型限制，不是推荐的通用部署方式。