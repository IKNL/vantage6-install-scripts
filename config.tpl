application:
  api_key: ${API_KEY}
  api_path: ''
  databases:
    default: C:\data\data.csv
  encryption:
    enabled: false
    private_key: ''
  logging:
    backup_count: 5
    datefmt: '%Y-%m-%d %H:%M:%S'
    file: eurasia.log
    format: '%(asctime)s - %(name)-14s - %(levelname)-8s - %(message)s'
    level: DEBUG
    max_size: 1024
    use_console: true
  port: '443'
  server_url: https://harukas.vantage6.ai
  task_dir: C:\Users\FMa1805.36838\AppData\Local\vantage6\node\eurasia
environments:
  acc: {}
  dev: {}
  prod: {}
  test: {}
