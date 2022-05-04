application:
  api_key: ${API_KEY}
  api_path: ''
  databases:
    default: ${DATA_FILE}
  encryption:
    enabled: false
    private_key: ''
  logging:
    backup_count: 5
    datefmt: '%Y-%m-%d %H:%M:%S'
    file: starter.log
    format: '%(asctime)s - %(name)-14s - %(levelname)-8s - %(message)s'
    level: DEBUG
    max_size: 1024
    use_console: true
  port: '443'
  server_url: https://starter.vantage6.ai
  task_dir: ${TASK_DIR}
  allowed_images:
    - ^harbor.vantage6.ai/starter/*
environments:
  acc: {}
  dev: {}
  prod: {}
  test: {}
