# Amazon EKSクライアントサーバ

## クライアントサーバ使用方法

### サーバにログインする

1. **AWSマネジメントコンソールにIAMユーザでログイン**
   - [AWSログインページ](https://signin.aws.amazon.com/)にアクセスし、アカウントID、IAMユーザ名、パスワードを入力してログイン

2. **EC2ダッシュボードに移動**
   - サービス一覧から「EC2」を選択

3. **インスタンスを確認**
   - 左側メニューの「インスタンス」をクリックし、クライアントサーバのインスタンスを確認

4. **対象インスタンスを起動 (停止状態のときのみ実行)**
   - ログインしたいインスタンスをクリックして選択
   - 右上の「インスタンスの状態」から「インスタンスを開始」を選択
   - インスタンスが「実行中」になることを確認

5. **インスタンスに接続**
   - ログインしたいインスタンスをクリックして選択
   - 右上の「接続」ボタンをクリック
   - 「EC2 Instance Connect」タブでユーザー名が「Ubuntu」であることを確認
   - 「接続」ボタンをクリック

### Kubernetesクラスタを作成する

1. **eksctlを実行**
   ```
   eksctl create cluster --name my-cluster --region ap-northeast-1 --nodes 2
   ```
   - `--name`：クラスター名
   - `--region`：デプロイするAWSリージョン( `ap-northeast-1` を指定)
   - `--nodes`：workerノード数(default: 2)

2. **コマンドの完了を待つ**
   - 完了まで15minほどかかる

3. **kubectlでクラスターにアクセスできることを確認**
   ```
   kubectl get nodes
   ```
   - 下記のようにworkerノードが出力される
      ```
      $ kubectl get nodes
      NAME                                                STATUS   ROLES    AGE   VERSION
      ip-192-168-47-234.ap-northeast-1.compute.internal   Ready    <none>   10m   v1.32.3-eks-473151a
      ip-192-168-92-180.ap-northeast-1.compute.internal   Ready    <none>   10m   v1.32.3-eks-473151a
      ```
      - masterノードはAWS管理のため表示されない

### Kubernetesクラスタの情報を確認する

1. **eksctlを実行**
   ```
   eksctl get cluster --region ap-northeast-1
   ```
   - `--region`：デプロイしたAWSリージョン( `ap-northeast-1` を指定)

### Kubernetesクラスタを削除する



1. **eksctlを実行**
   ```
   eksctl delete cluster --name my-cluster --region ap-northeast-1
   ```
   - `--name`：作成したクラスター名
   - `--region`：デプロイしたAWSリージョン( `ap-northeast-1` を指定)

2. **コマンドの完了を待つ**
   - 完了まで15minほどかかる

### クライアントサーバを停止する

1. **インスタンスの確認**  
   - 「[サーバにログインする](#サーバにログインする)」の手順1～3を参照し、クライアントサーバのインスタンスを一覧から確認

2. **対象インスタンスを停止**
   - 停止したいインスタンスをクリックして選択
   - 右上の「インスタンスの状態」から「インスタンスを停止」を選択
   - インスタンスの状態が「停止済み」になることを確認

## 環境構成

### CloudFormation template

テンプレートファイル: [template-minecraft.yml](/templates/ec2-eksctl-ubuntu.yaml)

下記のリソース群を管理する

![テンプレート](/templates/ec2-eksctl-ubuntu.png)

### 構成図

### 参考

- [eksctl公式ドキュメント](https://eksctl.io/)
