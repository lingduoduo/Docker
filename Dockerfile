FROM gcr.io/kubeflow-platform/spotify-kubeflow:0.5.4-dev0-py3

RUN apt-get update -y && \
    apt-get install build-essential -y && \
    apt-get install gcc gfortran libgomp1 -y

COPY base-component-requirements.txt /ml/base-component-requirements.txt
ENV BASE_PIP_REQUIREMENTS /ml/base-component-requirements.txt

COPY docker/xgboost/extra-requirements.txt extra-requirements.txt
RUN pip install -r extra-requirements.txt --index-url https://pypi.spotify.net/simple/ --upgrade

ENV EXTRA_PIP_REQUIREMENTS "/ml/extra-requirements.txt"

COPY ./src/spotify_kubeflow /ml/spotify_kubeflow

ENV PYTHONPATH "${PYTHONPATH}:/ml"
WORKDIR /ml

ENTRYPOINT ["python", "spotify_kubeflow/component/sdk/execution/run_component.py"]
