FROM python:3.10-slim


ENV PYTHONUNBUFFERED=1 \
    LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    SAM2_REPO_ROOT=/app/app/object_detection_and_SAM/sam2_model_info/sam2 \
    PYTHONPATH=/app:/app/app/object_detection_and_SAM/sam2_model_info/sam2:${PYTHONPATH}


RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    default-libmysqlclient-dev \
    pkg-config \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /app


COPY requirements.txt .


RUN pip install --upgrade pip && \
    pip install torch==2.0.1+cpu torchvision==0.15.2+cpu --index-url https://download.pytorch.org/whl/cpu && \
    pip install -r requirements.txt --no-cache-dir



RUN touch /.dockerenv

COPY . .


RUN mkdir -p uploads outputs exports_excel TEMP_FOLDER \
    app/outputLogs app/outputModel \
    app/object_detection_and_SAM/sam2_model_info/checkpoints \
    app/object_detection_and_SAM/weights


RUN cd /app/app/object_detection_and_SAM/sam2_model_info/sam2 && \
    pip install . && \
    echo "SAM2 installed successfully"


EXPOSE 7860


CMD python -m flask run --host=0.0.0.0 --port=7860
