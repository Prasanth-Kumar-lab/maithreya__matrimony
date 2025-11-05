import 'package:googleapis_auth/auth_io.dart';
class GetServerKey{
  Future<String> getServerKeyToken() async{
    final scopes =[
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(
          {
            "type": "service_account",
            "project_id": "matrimony-client-364d7",
            "private_key_id": "3bc4ff2deb404192843f0b54a3375ba0d8db4f10",
            "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCbA5v7dxJ2Qkpn\nWoW/er7XCU7kDNcszSelDLeHAPgclSYzavNgd7AuC/jKm2OOt2twJyMTsGjo4bhZ\nMVr1VUj47x/v8vn3ramHiYm2CdgdxmOcuR98P4EAmcgURVouv3UnRibRJjrosSKW\nzRtJY4OcPqTQh3qsLyxYXowfPtz/YO7/64mgzc7D+0yi3aRhP/ayKfr5jzaKWZrq\n6joGcW7C8UqBsXV0Zp6yb9u4WTJB8SlcYxPpFbVnCGJE6k3/PAD+5NQMgrU3/iwi\nUxkEftWDAyP4qsKGou6o22nz5APV0NZUVk78YYPHuQj4vJPmR+IYEeZpN57vVGAA\nUWUhNq15AgMBAAECggEAPtZnODgsCTlVHPFyj0zMKLJSwxo7baNaY0s06GqpqTiC\nzEwaDWxnRDtBJqx33qYWzNdonjYgSOsbRji+JP5l/tc8bJHj55WDx/gmlV8HNwax\nYZofm8fIXPx5wVHdvV6KOJn06Uqkjagkm9nYKldHRiKUwB1zSnIy+T2WcqIShwjb\nv4k5RXNNS9riEq4WfZr2gXxroAwNhsnxap45lH4vMDtJEUbb5TOCiQs8p0YVdsVt\nAh7RxhIEoRf9V9Z7RDwjSI9AtUFaQG4hD5y37avqmi6Lm2UUvVmxo8PAMaDgS5Rr\ndC0xjuK4NCUqtLDByukVHUBZ3KfaX48oY8gjSp0tCwKBgQDYDFsvvz5jUut8yl+C\n0p+wQkkR8Puqt9SR5IJq4gfXrwHxh4SV51zsMtfWQxkL+jFwhXTo7fx6n2wmzLOJ\npQkeq+NEc/ko0kToO0iB903BD+EI2gpQwziaFUCCsA+nV6ruFbqMshBE6NKlKp5F\ngVQpQax8rZGSkGW9oiqSgaJa+wKBgQC3reslK19vEq7h0QrYyGBRknfojVAwPwww\nyItpuVeWhkwuBzMGOGxhF2AxLqEis6ptm/4BiWEFrG9gXQlnUon2HXZUa34IeaDf\nDXVLyzz/Sacdy1RjsLoB4kuaSsz3XH8Uio4AQonMsBpfrqbYsjxL+p5y1ZZSX7Ks\naz3+BbkvGwKBgD0l+iUgdtL75CTUzoWjgYkMqcvHLiPalfKY/4Sq5tdX9C/dUFxx\nOG6t0UMWiJ9IN/gF/dnzidNXDfBJXcNmj5c7xT5ZqLqyEMi+Br6qNTqgeOvdcq/7\nISkTPMgAdt3BRWLPiZZKy6oFT6Fp15QKj7yBlwVOxvX5oqIypOQEhuRDAoGAUylD\nFYkVpExpMYRbzNqsAUK3V2rjq3RgKJYjyLJJnbUgOJa5208ggrT6sEnUWsnNl+LQ\nlhGFA/SWWKLG5yjPncapFH+2iE/JLjQBr1dNPqgyKaMtihUxoji60hibxEL0pnA0\n6pk1mp8A0eFZWTMZaa0GoCdj79e0JaxIXQJqXZECgYEAt9bSW6SuOG4p3VUGVwoR\n3MQLrSpLq2FECsOcjtmSbYBYUnrn2JCEpF0qdCfGIGfLfHJww/uDodAWl3iBSHwz\nefrSjOj8Fd+c/PE0ub4GsIu0d3jiQm2ECyPGnnvVwoWJHvqn3JRPwsJ076XcagQi\nWh0pQjH67uTOXHglRKm0bpA=\n-----END PRIVATE KEY-----\n",
            "client_email": "firebase-adminsdk-fbsvc@matrimony-client-364d7.iam.gserviceaccount.com",
            "client_id": "110719286877786660736",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40matrimony-client-364d7.iam.gserviceaccount.com",
            "universe_domain": "googleapis.com"
          }

      ),
      scopes,
    );
    final accessServerKey=client.credentials.accessToken.data;
    return accessServerKey;
  }
}