#dockerfile for python flask app from nathan
FROM python:latest
RUN mkdir flask_app
WORKDIR flask_app
RUN echo 'Updating cache'
COPY ./BirthDateAppFlask ./BirthDateAppFlask
RUN pip3 install -r BirthDateAppFlask/requirements.txt > /dev/null
RUN echo 'Installed pip succesfully'
ENTRYPOINT ["python3", "BirthDateAppFlask/app.py"]