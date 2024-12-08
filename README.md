# webm-to-mp4
A bash script that monitors a folder and automatically converts all new webm files to MP4 

The sole reason this exists is because literally no place supports .webm format and ubuntu screen recording produces this format and I couldnt find a way to change the foramt natively.


*Make sure you have ffmpeg and inotify-tools installed on your system. If not, you can install it by running the following command:*
    
```bash
sudo apt-get install ffmpeg
sudo apt-get install inotify-tools
```
## Usage:

### To run this script manually, follow these steps:

1. Clone this repository to your local machine:
    
    ```bash
    git clone https://github.com/i-am-zaidali/webm-to-mp4.git
    ```

2. Navigate to the project directory:

    ```bash
    cd webm-to-mp4
    ```

3. Make the script executable:

    ```bash
    chmod +x src/convert.sh
    ```

4. Run the script:

    ```bash
    ./src/convert.sh /path/to/directory
    ```
    Replace `/path/to/directory` with the path to the directory where you want to monitor for new webm files.

### To run this script as a daemon, follow these steps:

1. Clone this repository to your local machine:
    
    ```bash
    git clone https://github.com/i-am-zaidali/webm-to-mp4.git
    ```

2. Navigate to the project directory:

    ```bash
    cd webm-to-mp4
    ```

3. Make the script executable:

    ```bash
    chmod +x src/convert.sh
    ```

4. Create a new systemd service file:

    ```bash
    sudo nano /etc/systemd/system/webm-to-mp4.service
    ```

5. Add the following lines to the service file:

    ```bash
    [Unit]
    Description="WebM to MP4 Converter"
    After=network.target

    [Service]
    ExecStart=/path/to/webm-to-mp4/src/convert.sh /path/to/directory
    Restart=always

    [Install]
    WantedBy=multi-user.target
    ```
    Replace `/path/to/webm-to-mp4` with the path to the cloned repository and `/path/to/directory` with the path to the directory where you want to monitor for new webm files.

6. Reload the systemd daemon:

    ```bash
    sudo systemctl daemon-reload
    ```

7. Start the service:

    ```bash
    sudo systemctl start webm-to-mp4
    ```

8. Enable the service to start on boot:

    ```bash
    sudo systemctl enable webm-to-mp4
    ```

**The script will now monitor the specified input directory for any new webm files and automatically convert them to MP4 format in the output directory.**

## Contributing
Feel free to contribute to this project by creating a pull request. If you have any questions or suggestions, please open an issue.

