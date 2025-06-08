FROM python:3.9-slim
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ \
    && pip config set global.index https://mirrors.aliyun.com/pypi \
    && pip config set global.trusted-host mirrors.aliyun.com \
    && pip install flask
COPY app.py /app.py
CMD ["python", "/app.py"]