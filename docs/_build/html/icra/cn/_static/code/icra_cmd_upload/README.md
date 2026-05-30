# ICRA Upload Tool / ICRA 上传工具

Upload work to ICRA on-site competition (type=2 tasks).
上传作品至 ICRA 现场赛（type=2 任务）。

## Requirements / 依赖

- Python 3
- `gmssl` library (auto-installed on first run if missing / 首次运行自动安装):
  ```
  pip3 install gmssl
  ```

## Usage / 用法

### Interactive / 交互式

```
python3 icra-upload.py
```

Follow the prompts — username, password, task selection, work title, file path.
按提示输入用户名、密码、选择任务、作品名称、文件路径。

### Command-line / 命令行模式

```
python3 icra-upload.py -u <username> -p <password> -t 1 -n mywork -f ./result.zip
```

| Option / 参数 | Description / 说明 |
|---------------|-------------------|
| `-u` | Login username / 登录用户名 |
| `-p` | Login password, plaintext / 登录密码，明文，自动 SM2 加密 |
| `-t` | Task number / 任务序号：1 2 或 3 |
| `-n` | Work title / 作品名称 |
| `-f` | File path to upload / 要上传的文件路径 |
| `-d` | Work description, optional / 作品描述，可选 |

