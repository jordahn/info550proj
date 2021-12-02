1. Create a repository for output.
2. Pull Docker image with the following command:

    docker pull jordahnn/info550proj

3. Enter this command to run Docker image. Replace file path to your created repository.

    docker run -v /path/to/output_repository:/info550proj/output jordahnn/info550proj

4. africa_trade_report.html file should be found in the designated output repository.