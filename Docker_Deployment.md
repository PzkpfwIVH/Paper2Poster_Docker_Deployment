# 一、部署前提
## 1、环境

(1) OS: Windows 11 家庭版 \
(2) VPN: Clash for Windows

## 2、所需组件/应用

| 工具/应用 | 版本 |
|----|----|
| wsl | 2 |
| docker | 支持wsl2的任意版本 |

# 二、镜像构建

运行以下命令：
```bash
docker build -t paper2poster .
```
由于上述构建需要下载模型，建议使用vpn进行下载（注：下载的包总计大小 > 5GB）。

# 三、运行

不建议使用官方给的命令，由于docker run -rm会在容器运行完成后立刻删除容器，且输出路径为容器内路径，因此不可能运行后提取到对应输出。

## 1、容器创建

运行以下命令：
```bash
docker run -it paper2poster /bin/bash
```
让容器内的输入输出指向当前终端。

## 2、写入环境变量

在容器中执行以下命令之一：
```bash
echo "QWEN_API_KEY=\"your_api_key\"" > .env # 千问APIkey
echo "OPENAI_API_KEY=\"your_api_key\"" > .env # OpenAI的APIkey
echo "DEEPSEEK_API_KEY=\"your_api_key\"" > .env # Deepseek的APIkey
```
注意，Deepseek目前没有支持图像识别的模型，请后续根据需求填写模型名称。

## 3、解析并生成海报

在容器中执行以下命令：
```bash
python -m PosterAgent.new_pipeline --poster_path="/Paper2Poster-data/Data Masking System based on Ink Technology/Data Masking System based on Ink Technology.pdf" --model_name_t=qwen --model_name_v=qwen --poster_width_inches=48 --poster_height_inches=36
```
这样就得到了示例论文的海报和pptx文件。

# 四、输出结果获取

由于输出结果还存于容器中，此时再创建一个终端，在新终端中输入以下命令：

## 1、海报文件获取

以下为输出到宿主机桌面的示例：
```bash
docker cp {your_container_id}:"/app/<qwen-2.5-vl-72b_qwen-2.5-vl-72b>_generated_posters/Paper2Poster-data/Data Masking System based on Ink Technology/Data Masking System based on Ink Technology.pdf" "C:\Users\{your_os_id}\Desktop\Ink.pdf"
```
把对应容器id、源文件地址、目标文件地址改为实际的id和地址，即可得到对应内容。

## 2、pptx文件获取

以下为输出到宿主机桌面的示例：
```bash
docker cp {your_container_id}:"/app/<qwen-2.5-vl-72b_qwen-2.5-vl-72b>_generated_posters/Paper2Poster-data/Data Masking System based on Ink Technology/Data Masking System based on Ink Technology.pdf/Data_Masking_System_based_on_Ink_Technology.pptx" "C:\Users\{your_os_id}\Desktop\Ink.pptx"
```
自定义字段修改如上所述。