---
title: 默认模块
language_tabs:
  - shell: Shell
  - http: HTTP
  - javascript: JavaScript
  - ruby: Ruby
  - python: Python
  - php: PHP
  - java: Java
  - go: Go
toc_footers: []
includes: []
search: true
code_clipboard: true
highlight_theme: darkula
headingLevel: 2
generator: "@tarslib/widdershins v4.0.30"

---

# 默认模块

Base URLs:

# Authentication

# AI 模型桥接控制器。

## GET 查询 AI 服务健康状态。

GET /ai-model/healthz

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "": {}
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "": {}
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "": {}
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultMapObject](#schemaresultmapobject)|

# 楼栋控制器。

## POST 新增楼栋。

POST /building/add

> Body 请求参数

```json
{
  "buildingCode": "string",
  "buildingName": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|[BuildingCreateDTO](#schemabuildingcreatedto)| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## DELETE 根据ID删除楼栋。

DELETE /building/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |楼栋ID|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## GET 分页查询楼栋。

GET /building/page

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|pageNum|query|integer| 是 |页码，从1开始|
|pageSize|query|integer| 是 |每页大小|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "buildingCode": "",
        "buildingName": "",
        "orgName": "",
        "orgCode": ""
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "buildingCode": "",
        "buildingName": "",
        "orgName": "",
        "orgCode": ""
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultPageResultBuildingVO](#schemaresultpageresultbuildingvo)|

## PUT 修改楼栋。

PUT /building

> Body 请求参数

```json
{
  "id": 0,
  "buildingCode": "string",
  "buildingName": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|[BuildingUpdateDTO](#schemabuildingupdatedto)| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## GET 查询当前登录组织下楼栋与栏舍树。

GET /building/current

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "orgId": 0,
    "buildings": [
      {
        "id": 0,
        "code": "",
        "name": "",
        "pens": [
          {
            "id": 0,
            "code": "",
            "name": ""
          }
        ]
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "orgId": 0,
    "buildings": [
      {
        "id": 0,
        "code": "",
        "name": "",
        "pens": [
          {
            "id": 0,
            "code": "",
            "name": ""
          }
        ]
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultOrgBuildingAndPenVO](#schemaresultorgbuildingandpenvo)|

# 死猪上报控制器。

## POST 创建死猪上报。

POST /inventory/dead-pig

> Body 请求参数

```yaml
penId: 0
reportDate: string
captureTime: string
quantity: 1
remark: string
files: string

```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|object| 否 |none|
|» penId|body|integer(int64)| 是 |栏舍ID。|
|» reportDate|body|string| 是 |上报日期。|
|» captureTime|body|string| 否 |采集时间。|
|» quantity|body|integer| 是 |死猪数量。|
|» remark|body|string| 否 |备注。|
|» files|body|string(binary)| 是 |上报图片数组。|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "reportId": 0,
    "orgId": 0,
    "penId": 0,
    "reportDate": "",
    "quantity": 0,
    "remark": "",
    "status": "",
    "createdAt": "",
    "mediaList": [
      {
        "id": 0,
        "picturePath": "",
        "similarityScore": 0
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "reportId": 0,
    "orgId": 0,
    "penId": 0,
    "reportDate": "",
    "quantity": 0,
    "remark": "",
    "status": "",
    "createdAt": "",
    "mediaList": [
      {
        "id": 0,
        "picturePath": "",
        "similarityScore": 0
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[MonoResultDeadPigReportVO](#schemamonoresultdeadpigreportvo)|

## GET 查询栏舍当天死猪上报。

GET /inventory/dead-pig/daily

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|penId|query|integer| 是 |栏舍ID|
|date|query|string| 是 |日期|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": [
    {
      "reportId": 0,
      "orgId": 0,
      "penId": 0,
      "reportDate": "",
      "quantity": 0,
      "remark": "",
      "status": "",
      "createdAt": "",
      "mediaList": [
        {
          "id": 0,
          "picturePath": "",
          "similarityScore": 0
        }
      ]
    }
  ],
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": [
    {
      "reportId": 0,
      "orgId": 0,
      "penId": 0,
      "reportDate": "",
      "quantity": 0,
      "remark": "",
      "status": "",
      "createdAt": "",
      "mediaList": [
        {
          "id": 0,
          "picturePath": "",
          "similarityScore": 0
        }
      ]
    }
  ],
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultListDeadPigReportVO](#schemaresultlistdeadpigreportvo)|

# 员工控制器。

## POST 员工登录。

POST /user/login

> Body 请求参数

```json
{
  "username": "string",
  "password": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|[EmployeeLoginDTO](#schemaemployeelogindto)| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "id": 0,
    "orgId": 0,
    "username": "",
    "name": "",
    "profilePicture": "",
    "token": "",
    "organization": "",
    "admin": false
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "id": 0,
    "orgId": 0,
    "username": "",
    "name": "",
    "profilePicture": "",
    "token": "",
    "organization": "",
    "admin": false
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultEmployeeVO](#schemaresultemployeevo)|

## POST 新增员工。

POST /user/register

> Body 请求参数

```yaml
id: 0
username: string
password: stringst
name: string
sex: string
phone: string
createTime: string
profilePicture: string
organization: string
admin: true
orgId: 0
picture: string

```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|object| 否 |none|
|» id|body|integer(int64)| 否 |员工ID。|
|» username|body|string| 是 |登录用户名。|
|» password|body|string| 是 |登录密码。|
|» name|body|string| 是 |员工姓名。|
|» sex|body|string| 是 |性别。|
|» phone|body|string| 否 |手机号。|
|» createTime|body|string| 否 |创建时间。|
|» profilePicture|body|string| 否 |头像对象Key。|
|» organization|body|string| 是 |组织名称。|
|» admin|body|boolean| 是 |是否管理员。|
|» orgId|body|integer(int64)| 是 |所属组织ID。|
|» picture|body|string(binary)| 否 |头像文件|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## PUT 修改员工信息。

PUT /user

> Body 请求参数

```yaml
id: 0
username: string
password: string
name: string
sex: string
phone: string
createTime: string
profilePicture: string
organization: string
admin: true
orgId: 0
picture: string

```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|object| 否 |none|
|» id|body|integer(int64)| 否 |员工ID。|
|» username|body|string| 否 |登录用户名。|
|» password|body|string| 否 |登录密码。|
|» name|body|string| 是 |员工姓名。|
|» sex|body|string| 是 |性别。|
|» phone|body|string| 否 |手机号。|
|» createTime|body|string| 否 |创建时间。|
|» profilePicture|body|string| 否 |头像对象Key。|
|» organization|body|string| 否 |组织名称。|
|» admin|body|boolean| 是 |是否管理员。|
|» orgId|body|integer(int64)| 是 |所属组织ID。|
|» picture|body|string(binary)| 否 |头像文件|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## DELETE 根据ID删除员工。

DELETE /user/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |员工ID|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## GET 根据ID查询员工。

GET /user/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |员工ID|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "id": 0,
    "username": "",
    "password": "",
    "name": "",
    "sex": "",
    "phone": "",
    "createTime": "",
    "profilePicture": "",
    "organization": "",
    "admin": false,
    "orgId": 0
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "id": 0,
    "username": "",
    "password": "",
    "name": "",
    "sex": "",
    "phone": "",
    "createTime": "",
    "profilePicture": "",
    "organization": "",
    "admin": false,
    "orgId": 0
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultEmployee](#schemaresultemployee)|

## POST 按条件查询员工。

POST /user/search

> Body 请求参数

```json
{
  "id": 0,
  "username": "string",
  "password": "string",
  "name": "string",
  "sex": "string",
  "phone": "string",
  "createTime": "string",
  "profilePicture": "string",
  "organization": "string",
  "admin": true,
  "orgId": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|[Employee](#schemaemployee)| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "username": "",
        "password": "",
        "name": "",
        "sex": "",
        "phone": "",
        "createTime": "",
        "profilePicture": "",
        "organization": "",
        "admin": false,
        "orgId": 0
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "username": "",
        "password": "",
        "name": "",
        "sex": "",
        "phone": "",
        "createTime": "",
        "profilePicture": "",
        "organization": "",
        "admin": false,
        "orgId": 0
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultPageResultEmployee](#schemaresultpageresultemployee)|

## DELETE 批量删除员工。

DELETE /user/batch

> Body 请求参数

```json
[
  0
]
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|array[integer]| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## GET 分页查询员工。

GET /user/page

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|pageNum|query|integer| 是 |页码，从1开始|
|pageSize|query|integer| 是 |每页大小|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "username": "",
        "password": "",
        "name": "",
        "sex": "",
        "phone": "",
        "createTime": "",
        "profilePicture": "",
        "organization": "",
        "admin": false,
        "orgId": 0
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "username": "",
        "password": "",
        "name": "",
        "sex": "",
        "phone": "",
        "createTime": "",
        "profilePicture": "",
        "organization": "",
        "admin": false,
        "orgId": 0
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultPageResultEmployee](#schemaresultpageresultemployee)|

## POST 退出登录。

POST /user/logout

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

# 盘点媒体控制器。

## POST 上传已绑定栏舍的盘点媒体。

POST /inventory/media/upload

> Body 请求参数

```yaml
taskId: 0
penId: 0
captureTime: string
files: string

```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|object| 否 |none|
|» taskId|body|integer(int64)| 是 |任务ID。|
|» penId|body|integer(int64)| 是 |栏舍ID。|
|» captureTime|body|string| 否 |采集时间。|
|» files|body|string(binary)| 是 |上传文件数组。|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "taskId": 0,
    "createdItems": [
      {
        "mediaId": 0,
        "taskId": 0,
        "penId": 0,
        "mediaType": "",
        "picturePath": "",
        "outputPicturePath": "",
        "thumbnailPath": "",
        "count": 0,
        "processingStatus": "",
        "processingMessage": "",
        "captureTime": ""
      }
    ],
    "duplicateItems": [
      {
        "fileName": "",
        "duplicateOfMediaId": 0,
        "duplicateOfTaskId": 0,
        "duplicateOfPenId": 0,
        "existingPicturePath": "",
        "existingCaptureTime": "",
        "similarityScore": 0,
        "message": ""
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "taskId": 0,
    "createdItems": [
      {
        "mediaId": 0,
        "taskId": 0,
        "penId": 0,
        "mediaType": "",
        "picturePath": "",
        "outputPicturePath": "",
        "thumbnailPath": "",
        "count": 0,
        "processingStatus": "",
        "processingMessage": "",
        "captureTime": ""
      }
    ],
    "duplicateItems": [
      {
        "fileName": "",
        "duplicateOfMediaId": 0,
        "duplicateOfTaskId": 0,
        "duplicateOfPenId": 0,
        "existingPicturePath": "",
        "existingCaptureTime": "",
        "similarityScore": 0,
        "message": ""
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[MonoResultInventoryMediaUploadResultVO](#schemamonoresultinventorymediauploadresultvo)|

## POST 上传未绑定栏舍的盘点媒体。

POST /inventory/media/upload/unbound

> Body 请求参数

```yaml
taskId: 0
captureTime: string
files: string

```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|object| 否 |none|
|» taskId|body|integer(int64)| 是 |任务ID。|
|» captureTime|body|string| 否 |采集时间。|
|» files|body|string(binary)| 是 |上传文件数组。|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "taskId": 0,
    "createdItems": [
      {
        "mediaId": 0,
        "taskId": 0,
        "penId": 0,
        "mediaType": "",
        "picturePath": "",
        "outputPicturePath": "",
        "thumbnailPath": "",
        "count": 0,
        "processingStatus": "",
        "processingMessage": "",
        "captureTime": ""
      }
    ],
    "duplicateItems": [
      {
        "fileName": "",
        "duplicateOfMediaId": 0,
        "duplicateOfTaskId": 0,
        "duplicateOfPenId": 0,
        "existingPicturePath": "",
        "existingCaptureTime": "",
        "similarityScore": 0,
        "message": ""
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "taskId": 0,
    "createdItems": [
      {
        "mediaId": 0,
        "taskId": 0,
        "penId": 0,
        "mediaType": "",
        "picturePath": "",
        "outputPicturePath": "",
        "thumbnailPath": "",
        "count": 0,
        "processingStatus": "",
        "processingMessage": "",
        "captureTime": ""
      }
    ],
    "duplicateItems": [
      {
        "fileName": "",
        "duplicateOfMediaId": 0,
        "duplicateOfTaskId": 0,
        "duplicateOfPenId": 0,
        "existingPicturePath": "",
        "existingCaptureTime": "",
        "similarityScore": 0,
        "message": ""
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[MonoResultInventoryMediaUploadResultVO](#schemamonoresultinventorymediauploadresultvo)|

## PUT 绑定媒体到栏舍。

PUT /inventory/media/bind

> Body 请求参数

```json
{
  "penId": 0,
  "mediaIds": [
    0
  ]
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|[InventoryMediaBindDTO](#schemainventorymediabinddto)| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## GET 查询栏舍当天媒体库。

GET /inventory/media/library

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|penId|query|integer| 是 |栏舍ID|
|date|query|string| 是 |日期|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": [
    {
      "id": 0,
      "taskId": 0,
      "orgId": 0,
      "penId": 0,
      "mediaType": "",
      "picturePath": "",
      "outputPicturePath": "",
      "thumbnailPath": "",
      "time": "",
      "captureTime": "",
      "dayBucket": "",
      "count": 0,
      "manualCount": 0,
      "processingStatus": "",
      "processingMessage": "",
      "status": false,
      "duplicate": false,
      "analysisJson": ""
    }
  ],
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": [
    {
      "id": 0,
      "taskId": 0,
      "orgId": 0,
      "penId": 0,
      "mediaType": "",
      "picturePath": "",
      "outputPicturePath": "",
      "thumbnailPath": "",
      "time": "",
      "captureTime": "",
      "dayBucket": "",
      "count": 0,
      "manualCount": 0,
      "processingStatus": "",
      "processingMessage": "",
      "status": false,
      "duplicate": false,
      "analysisJson": ""
    }
  ],
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultListPenMediaVO](#schemaresultlistpenmediavo)|

## GET 查询任务下未绑定栏舍的媒体。

GET /inventory/media/unbound

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|taskId|query|integer| 是 |任务ID|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": [
    {
      "id": 0,
      "taskId": 0,
      "orgId": 0,
      "penId": 0,
      "mediaType": "",
      "picturePath": "",
      "outputPicturePath": "",
      "thumbnailPath": "",
      "time": "",
      "captureTime": "",
      "dayBucket": "",
      "count": 0,
      "manualCount": 0,
      "processingStatus": "",
      "processingMessage": "",
      "status": false,
      "duplicate": false,
      "analysisJson": ""
    }
  ],
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": [
    {
      "id": 0,
      "taskId": 0,
      "orgId": 0,
      "penId": 0,
      "mediaType": "",
      "picturePath": "",
      "outputPicturePath": "",
      "thumbnailPath": "",
      "time": "",
      "captureTime": "",
      "dayBucket": "",
      "count": 0,
      "manualCount": 0,
      "processingStatus": "",
      "processingMessage": "",
      "status": false,
      "duplicate": false,
      "analysisJson": ""
    }
  ],
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultListPenMediaVO](#schemaresultlistpenmediavo)|

## DELETE 删除单个媒体。

DELETE /inventory/media/{mediaId}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|mediaId|path|integer| 是 |媒体ID|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## POST 确认媒体。

POST /inventory/media/confirm

> Body 请求参数

```json
{
  "mediaIds": [
    0
  ],
  "status": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|[ConfirmPenPictureDTO](#schemaconfirmpenpicturedto)| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## POST 解锁媒体。

POST /inventory/media/unlock

> Body 请求参数

```json
{
  "mediaIds": [
    0
  ],
  "status": true
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|[ConfirmPenPictureDTO](#schemaconfirmpenpicturedto)| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## POST 更新人工盘点数量。

POST /inventory/media/manual-count

> Body 请求参数

```json
{
  "mediaId": 0,
  "manualCount": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|[ManualCountUpdateDTO](#schemamanualcountupdatedto)| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## GET 统计栏舍区间盘点汇总。

GET /inventory/media/summary

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|penId|query|integer| 是 |栏舍ID|
|startDate|query|string| 是 |开始日期|
|endDate|query|string| 是 |结束日期|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "statDate": "",
        "sampleSize": 0,
        "avgCount": 0,
        "minCount": 0,
        "maxCount": 0
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "statDate": "",
        "sampleSize": 0,
        "avgCount": 0,
        "minCount": 0,
        "maxCount": 0
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultPageResultPenMediaSummaryVO](#schemaresultpageresultpenmediasummaryvo)|

# 盘点报表控制器。

## GET 查询盘点日报。

GET /inventory/report/daily

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|date|query|string| 是 |日期|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "orgId": 0,
    "orgName": "",
    "reportDate": "",
    "buildings": [
      {
        "buildingId": 0,
        "buildingName": "",
        "pens": [
          {
            "penId": 0,
            "penName": "",
            "sampleSize": 0,
            "avgCount": 0,
            "minCount": 0,
            "maxCount": 0,
            "finalCount": 0,
            "deadPigQuantity": 0
          }
        ]
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "orgId": 0,
    "orgName": "",
    "reportDate": "",
    "buildings": [
      {
        "buildingId": 0,
        "buildingName": "",
        "pens": [
          {
            "penId": 0,
            "penName": "",
            "sampleSize": 0,
            "avgCount": 0,
            "minCount": 0,
            "maxCount": 0,
            "finalCount": 0,
            "deadPigQuantity": 0
          }
        ]
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultDailyInventoryReportVO](#schemaresultdailyinventoryreportvo)|

## GET 查询综合盘点报告。

GET /inventory/report/comprehensive

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|startDate|query|string| 是 |开始日期|
|endDate|query|string| 是 |结束日期|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "orgId": 0,
    "orgName": "",
    "startDate": "",
    "endDate": "",
    "buildings": [
      {
        "buildingId": 0,
        "buildingName": "",
        "pens": [
          {
            "penId": 0,
            "penName": "",
            "includedDays": 0,
            "avgDailyCount": 0,
            "recommendedCount": 0,
            "deadPigQuantity": 0,
            "dailySnapshots": [
              {
                "statDate": "",
                "sampleSize": 0,
                "avgCount": 0,
                "finalCount": 0
              }
            ]
          }
        ]
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "orgId": 0,
    "orgName": "",
    "startDate": "",
    "endDate": "",
    "buildings": [
      {
        "buildingId": 0,
        "buildingName": "",
        "pens": [
          {
            "penId": 0,
            "penName": "",
            "includedDays": 0,
            "avgDailyCount": 0,
            "recommendedCount": 0,
            "deadPigQuantity": 0,
            "dailySnapshots": [
              {
                "statDate": "",
                "sampleSize": 0,
                "avgCount": 0,
                "finalCount": 0
              }
            ]
          }
        ]
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultComprehensiveInventoryReportVO](#schemaresultcomprehensiveinventoryreportvo)|

## GET 导出盘点日报 PDF。

GET /inventory/report/daily/pdf

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|date|query|string| 是 |日期|
|regenerate|query|boolean| 是 |是否强制重生成|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "objectKey": "",
    "accessUrl": "",
    "fileName": "",
    "generatedAt": "",
    "cached": false
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "objectKey": "",
    "accessUrl": "",
    "fileName": "",
    "generatedAt": "",
    "cached": false
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultPdfExportVO](#schemaresultpdfexportvo)|

## GET 导出综合盘点报告 PDF。

GET /inventory/report/comprehensive/pdf

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|startDate|query|string| 是 |开始日期|
|endDate|query|string| 是 |结束日期|
|regenerate|query|boolean| 是 |是否强制重生成|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "objectKey": "",
    "accessUrl": "",
    "fileName": "",
    "generatedAt": "",
    "cached": false
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "objectKey": "",
    "accessUrl": "",
    "fileName": "",
    "generatedAt": "",
    "cached": false
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultPdfExportVO](#schemaresultpdfexportvo)|

# 组织控制器。

## POST 新增组织。

POST /org/add

> Body 请求参数

```json
{
  "orgCode": "string",
  "orgName": "string",
  "logo": "string",
  "adminName": "string",
  "tel": "string",
  "addr": "string",
  "photoDedupWindowDays": 1
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|[OrganizationCreateDTO](#schemaorganizationcreatedto)| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## PUT 修改组织。

PUT /org

> Body 请求参数

```json
{
  "id": 0,
  "orgCode": "string",
  "orgName": "string",
  "logo": "string",
  "adminName": "string",
  "tel": "string",
  "addr": "string",
  "photoDedupWindowDays": 1
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|[OrganizationUpdateDTO](#schemaorganizationupdatedto)| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## DELETE 删除组织。

DELETE /org/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |组织ID|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## GET 分页查询组织。

GET /org/page

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|pageNum|query|integer| 是 |页码，从1开始|
|pageSize|query|integer| 是 |每页大小|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "orgCode": "",
        "erpId": "",
        "orgName": "",
        "logo": "",
        "adminName": "",
        "tel": "",
        "addr": "",
        "photoDedupWindowDays": 0,
        "source": "",
        "enabled": false
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "orgCode": "",
        "erpId": "",
        "orgName": "",
        "logo": "",
        "adminName": "",
        "tel": "",
        "addr": "",
        "photoDedupWindowDays": 0,
        "source": "",
        "enabled": false
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultPageResultOrganization](#schemaresultpageresultorganization)|

## POST 触发组织ERP同步。

POST /org/erp/sync

仅用于兼容旧入口。

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      ""
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      ""
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultPageResultString](#schemaresultpageresultstring)|

# 栏舍控制器。

## POST 新增栏舍。

POST /pen/add

> Body 请求参数

```json
{
  "buildingId": 0,
  "penCode": "string",
  "penName": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|[PenCreateDTO](#schemapencreatedto)| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## DELETE 根据ID删除栏舍。

DELETE /pen/{id}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|id|path|integer| 是 |栏舍ID|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## GET 分页查询栏舍。

GET /pen/page

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|pageNum|query|integer| 是 |页码，从1开始|
|pageSize|query|integer| 是 |每页大小|
|buildingId|query|integer| 是 |楼栋ID|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "penCode": "",
        "penName": "",
        "buildingCode": "",
        "buildingName": ""
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "penCode": "",
        "penName": "",
        "buildingCode": "",
        "buildingName": ""
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "penCode": "",
        "penName": "",
        "buildingCode": "",
        "buildingName": ""
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultPageResultPenVO](#schemaresultpageresultpenvo)|

## GET 查询栏舍详情看板。

GET /pen/overview

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|penId|query|integer| 是 |栏舍ID|
|date|query|string| 否 |当前聚焦日期|
|startDate|query|string| 否 |趋势开始日期|
|endDate|query|string| 否 |趋势结束日期|
|recentMediaLimit|query|integer| 否 |最近媒体数量限制|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "orgId": 0,
    "orgName": "",
    "buildingId": 0,
    "buildingName": "",
    "penId": 0,
    "penCode": "",
    "penName": "",
    "focusDate": "",
    "trendStartDate": "",
    "trendEndDate": "",
    "todayLiveStat": {
      "sampleSize": 0,
      "avgCount": 0,
      "minCount": 0,
      "maxCount": 0,
      "finalCount": 0,
      "deadPigQuantity": 0
    },
    "todayConfirmedStat": {
      "sampleSize": 0,
      "avgCount": 0,
      "minCount": 0,
      "maxCount": 0,
      "finalCount": 0,
      "deadPigQuantity": 0
    },
    "todayMediaSummary": {
      "totalMediaCount": 0,
      "imageMediaCount": 0,
      "videoMediaCount": 0,
      "confirmedMediaCount": 0,
      "unconfirmedMediaCount": 0,
      "pendingMediaCount": 0,
      "processingMediaCount": 0,
      "successMediaCount": 0,
      "failedMediaCount": 0
    },
    "latestMedia": {
      "id": 0,
      "taskId": 0,
      "orgId": 0,
      "penId": 0,
      "mediaType": "",
      "picturePath": "",
      "outputPicturePath": "",
      "thumbnailPath": "",
      "time": "",
      "captureTime": "",
      "dayBucket": "",
      "count": 0,
      "manualCount": 0,
      "processingStatus": "",
      "processingMessage": "",
      "status": false,
      "duplicate": false,
      "analysisJson": ""
    },
    "recentMedia": [
      {
        "id": 0,
        "taskId": 0,
        "orgId": 0,
        "penId": 0,
        "mediaType": "",
        "picturePath": "",
        "outputPicturePath": "",
        "thumbnailPath": "",
        "time": "",
        "captureTime": "",
        "dayBucket": "",
        "count": 0,
        "manualCount": 0,
        "processingStatus": "",
        "processingMessage": "",
        "status": false,
        "duplicate": false,
        "analysisJson": ""
      }
    ],
    "confirmedTrend": [
      {
        "statDate": "",
        "sampleSize": 0,
        "avgCount": 0,
        "minCount": 0,
        "maxCount": 0,
        "finalCount": 0,
        "deadPigQuantity": 0
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "orgId": 0,
    "orgName": "",
    "buildingId": 0,
    "buildingName": "",
    "penId": 0,
    "penCode": "",
    "penName": "",
    "focusDate": "",
    "trendStartDate": "",
    "trendEndDate": "",
    "todayLiveStat": {
      "sampleSize": 0,
      "avgCount": 0,
      "minCount": 0,
      "maxCount": 0,
      "finalCount": 0,
      "deadPigQuantity": 0
    },
    "todayConfirmedStat": {
      "sampleSize": 0,
      "avgCount": 0,
      "minCount": 0,
      "maxCount": 0,
      "finalCount": 0,
      "deadPigQuantity": 0
    },
    "todayMediaSummary": {
      "totalMediaCount": 0,
      "imageMediaCount": 0,
      "videoMediaCount": 0,
      "confirmedMediaCount": 0,
      "unconfirmedMediaCount": 0,
      "pendingMediaCount": 0,
      "processingMediaCount": 0,
      "successMediaCount": 0,
      "failedMediaCount": 0
    },
    "latestMedia": {
      "id": 0,
      "taskId": 0,
      "orgId": 0,
      "penId": 0,
      "mediaType": "",
      "picturePath": "",
      "outputPicturePath": "",
      "thumbnailPath": "",
      "time": "",
      "captureTime": "",
      "dayBucket": "",
      "count": 0,
      "manualCount": 0,
      "processingStatus": "",
      "processingMessage": "",
      "status": false,
      "duplicate": false,
      "analysisJson": ""
    },
    "recentMedia": [
      {
        "id": 0,
        "taskId": 0,
        "orgId": 0,
        "penId": 0,
        "mediaType": "",
        "picturePath": "",
        "outputPicturePath": "",
        "thumbnailPath": "",
        "time": "",
        "captureTime": "",
        "dayBucket": "",
        "count": 0,
        "manualCount": 0,
        "processingStatus": "",
        "processingMessage": "",
        "status": false,
        "duplicate": false,
        "analysisJson": ""
      }
    ],
    "confirmedTrend": [
      {
        "statDate": "",
        "sampleSize": 0,
        "avgCount": 0,
        "minCount": 0,
        "maxCount": 0,
        "finalCount": 0,
        "deadPigQuantity": 0
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "orgId": 0,
    "orgName": "",
    "buildingId": 0,
    "buildingName": "",
    "penId": 0,
    "penCode": "",
    "penName": "",
    "focusDate": "",
    "trendStartDate": "",
    "trendEndDate": "",
    "todayLiveStat": {
      "sampleSize": 0,
      "avgCount": 0,
      "minCount": 0,
      "maxCount": 0,
      "finalCount": 0,
      "deadPigQuantity": 0
    },
    "todayConfirmedStat": {
      "sampleSize": 0,
      "avgCount": 0,
      "minCount": 0,
      "maxCount": 0,
      "finalCount": 0,
      "deadPigQuantity": 0
    },
    "todayMediaSummary": {
      "totalMediaCount": 0,
      "imageMediaCount": 0,
      "videoMediaCount": 0,
      "confirmedMediaCount": 0,
      "unconfirmedMediaCount": 0,
      "pendingMediaCount": 0,
      "processingMediaCount": 0,
      "successMediaCount": 0,
      "failedMediaCount": 0
    },
    "latestMedia": {
      "id": 0,
      "taskId": 0,
      "orgId": 0,
      "penId": 0,
      "mediaType": "",
      "picturePath": "",
      "outputPicturePath": "",
      "thumbnailPath": "",
      "time": "",
      "captureTime": "",
      "dayBucket": "",
      "count": 0,
      "manualCount": 0,
      "processingStatus": "",
      "processingMessage": "",
      "status": false,
      "duplicate": false,
      "analysisJson": ""
    },
    "recentMedia": [
      {
        "id": 0,
        "taskId": 0,
        "orgId": 0,
        "penId": 0,
        "mediaType": "",
        "picturePath": "",
        "outputPicturePath": "",
        "thumbnailPath": "",
        "time": "",
        "captureTime": "",
        "dayBucket": "",
        "count": 0,
        "manualCount": 0,
        "processingStatus": "",
        "processingMessage": "",
        "status": false,
        "duplicate": false,
        "analysisJson": ""
      }
    ],
    "confirmedTrend": [
      {
        "statDate": "",
        "sampleSize": 0,
        "avgCount": 0,
        "minCount": 0,
        "maxCount": 0,
        "finalCount": 0,
        "deadPigQuantity": 0
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultPenInventoryOverviewVO](#schemaresultpeninventoryoverviewvo)|

## PUT 修改栏舍。

PUT /pen

> Body 请求参数

```json
{
  "id": 0,
  "buildingId": 0,
  "penCode": "string",
  "penName": "string"
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|[PenUpdateDTO](#schemapenupdatedto)| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

# 盘点任务控制器。

## POST 新增任务。

POST /task/add

> Body 请求参数

```json
{
  "id": 0,
  "employeeId": 0,
  "taskName": "string",
  "startTime": "string",
  "endTime": "string",
  "buildings": [
    {
      "buildingId": 0,
      "pens": [
        {
          "penId": 0
        }
      ]
    }
  ],
  "orgId": 0
}
```

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|Authorization|header|string| 否 |none|
|body|body|[TaskDTO](#schemataskdto)| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## GET 根据员工ID查询任务。

GET /task/{employeeId}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|employeeId|path|integer| 是 |员工ID|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "taskName": "",
        "employeeId": 0,
        "startTime": "",
        "endTime": "",
        "valid": false,
        "orgId": 0,
        "taskStatus": "",
        "issuedBy": 0,
        "issuedAt": "",
        "receivedAt": "",
        "completedAt": ""
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "taskName": "",
        "employeeId": 0,
        "startTime": "",
        "endTime": "",
        "valid": false,
        "orgId": 0,
        "taskStatus": "",
        "issuedBy": 0,
        "issuedAt": "",
        "receivedAt": "",
        "completedAt": ""
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultPageResultTask](#schemaresultpageresulttask)|

## GET 分页查询任务。

GET /task/page

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|pageNum|query|integer| 是 |页码，从1开始|
|pageSize|query|integer| 是 |每页大小|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "taskName": "",
        "employeeId": 0,
        "startTime": "",
        "endTime": "",
        "valid": false,
        "orgId": 0,
        "taskStatus": "",
        "issuedBy": 0,
        "issuedAt": "",
        "receivedAt": "",
        "completedAt": ""
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "taskName": "",
        "employeeId": 0,
        "startTime": "",
        "endTime": "",
        "valid": false,
        "orgId": 0,
        "taskStatus": "",
        "issuedBy": 0,
        "issuedAt": "",
        "receivedAt": "",
        "completedAt": ""
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultPageResultTask](#schemaresultpageresulttask)|

## GET 查询任务详情。

GET /task/detail/{taskId}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|taskId|path|integer| 是 |任务ID|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": {
    "id": 0,
    "employeeId": 0,
    "taskName": "",
    "startTime": "",
    "endTime": "",
    "orgId": 0,
    "taskStatus": "",
    "issuedAt": "",
    "receivedAt": "",
    "completedAt": "",
    "assignedPenCount": 0,
    "uploadedPenCount": 0,
    "confirmedPenCount": 0,
    "processingPenCount": 0,
    "failedPenCount": 0,
    "unboundMediaCount": 0,
    "buildings": [
      {
        "buildingId": 0,
        "buildingName": "",
        "pens": [
          {
            "penId": 0,
            "penName": "",
            "mediaType": "",
            "count": 0,
            "picturePath": "",
            "outputPicturePath": "",
            "thumbnailPath": "",
            "manualCount": 0,
            "processingStatus": "",
            "processingMessage": "",
            "status": false
          }
        ]
      }
    ]
  },
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": {
    "id": 0,
    "employeeId": 0,
    "taskName": "",
    "startTime": "",
    "endTime": "",
    "orgId": 0,
    "taskStatus": "",
    "issuedAt": "",
    "receivedAt": "",
    "completedAt": "",
    "assignedPenCount": 0,
    "uploadedPenCount": 0,
    "confirmedPenCount": 0,
    "processingPenCount": 0,
    "failedPenCount": 0,
    "unboundMediaCount": 0,
    "buildings": [
      {
        "buildingId": 0,
        "buildingName": "",
        "pens": [
          {
            "penId": 0,
            "penName": "",
            "mediaType": "",
            "count": 0,
            "picturePath": "",
            "outputPicturePath": "",
            "thumbnailPath": "",
            "manualCount": 0,
            "processingStatus": "",
            "processingMessage": "",
            "status": false
          }
        ]
      }
    ]
  },
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultDetailTaskDTO](#schemaresultdetailtaskdto)|

## POST 接收任务。

POST /task/receive/{taskId}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|taskId|path|integer| 是 |任务ID|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

## POST 完成任务。

POST /task/complete/{taskId}

### 请求参数

|名称|位置|类型|必选|说明|
|---|---|---|---|---|
|taskId|path|integer| 是 |任务ID|
|Authorization|header|string| 否 |none|

> 返回示例

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

```json
{
  "code": 0,
  "message": "",
  "data": null,
  "ok": false
}
```

### 返回结果

|状态码|状态码含义|说明|数据模型|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|[ResultVoid](#schemaresultvoid)|

# 数据模型

<h2 id="tocS_key">key</h2>

<a id="schemakey"></a>
<a id="schema_key"></a>
<a id="tocSkey"></a>
<a id="tocskey"></a>

```json
{}

```

### 属性

*None*

<h2 id="tocS_ResultVoid">ResultVoid</h2>

<a id="schemaresultvoid"></a>
<a id="schema_ResultVoid"></a>
<a id="tocSresultvoid"></a>
<a id="tocsresultvoid"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": null,
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|null|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_EmployeeVO">EmployeeVO</h2>

<a id="schemaemployeevo"></a>
<a id="schema_EmployeeVO"></a>
<a id="tocSemployeevo"></a>
<a id="tocsemployeevo"></a>

```json
{
  "id": 0,
  "orgId": 0,
  "username": "string",
  "name": "string",
  "profilePicture": "string",
  "token": "string",
  "organization": "string",
  "admin": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||员工ID。|
|orgId|integer(int64)|false|none||所属组织ID。|
|username|string|false|none||用户名。|
|name|string|false|none||姓名。|
|profilePicture|string|false|none||头像地址。|
|token|string|false|none||JWT令牌。|
|organization|string|false|none||所属组织名称。|
|admin|boolean|false|none||是否管理员。|

<h2 id="tocS_InventoryMediaItemVO">InventoryMediaItemVO</h2>

<a id="schemainventorymediaitemvo"></a>
<a id="schema_InventoryMediaItemVO"></a>
<a id="tocSinventorymediaitemvo"></a>
<a id="tocsinventorymediaitemvo"></a>

```json
{
  "mediaId": 0,
  "taskId": 0,
  "penId": 0,
  "mediaType": "string",
  "picturePath": "string",
  "outputPicturePath": "string",
  "thumbnailPath": "string",
  "count": 0,
  "processingStatus": "string",
  "processingMessage": "string",
  "captureTime": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|mediaId|integer(int64)|false|none||媒体ID。|
|taskId|integer(int64)|false|none||任务ID。|
|penId|integer(int64)|false|none||栏舍ID。|
|mediaType|string|false|none||媒体类型。|
|picturePath|string|false|none||原始媒体访问地址。|
|outputPicturePath|string|false|none||输出媒体访问地址。|
|thumbnailPath|string|false|none||预览缩略图访问地址。|
|count|integer|false|none||模型盘点数量。|
|processingStatus|string|false|none||媒体处理状态。|
|processingMessage|string|false|none||媒体处理提示。|
|captureTime|string|false|none||采集时间。|

<h2 id="tocS_MapObject">MapObject</h2>

<a id="schemamapobject"></a>
<a id="schema_MapObject"></a>
<a id="tocSmapobject"></a>
<a id="tocsmapobject"></a>

```json
{
  "key": {}
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|key|[key](#schemakey)|false|none||none|

<h2 id="tocS_Building">Building</h2>

<a id="schemabuilding"></a>
<a id="schema_Building"></a>
<a id="tocSbuilding"></a>
<a id="tocsbuilding"></a>

```json
{
  "id": 0,
  "orgId": 0,
  "buildingCode": "string",
  "erpId": "string",
  "buildingName": "string",
  "source": "string",
  "enabled": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||楼栋ID。|
|orgId|integer(int64)|true|none||所属组织ID。|
|buildingCode|string|true|none||楼栋编码。|
|erpId|string|false|none||ERP楼栋ID。|
|buildingName|string|true|none||楼栋名称。|
|source|string|false|none||数据来源。|
|enabled|boolean|false|none||是否启用。|

<h2 id="tocS_ResultEmployeeVO">ResultEmployeeVO</h2>

<a id="schemaresultemployeevo"></a>
<a id="schema_ResultEmployeeVO"></a>
<a id="tocSresultemployeevo"></a>
<a id="tocsresultemployeevo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "id": 0,
    "orgId": 0,
    "username": "string",
    "name": "string",
    "profilePicture": "string",
    "token": "string",
    "organization": "string",
    "admin": true
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[EmployeeVO](#schemaemployeevo)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_DuplicateMediaItemVO">DuplicateMediaItemVO</h2>

<a id="schemaduplicatemediaitemvo"></a>
<a id="schema_DuplicateMediaItemVO"></a>
<a id="tocSduplicatemediaitemvo"></a>
<a id="tocsduplicatemediaitemvo"></a>

```json
{
  "fileName": "string",
  "duplicateOfMediaId": 0,
  "duplicateOfTaskId": 0,
  "duplicateOfPenId": 0,
  "existingPicturePath": "string",
  "existingCaptureTime": "string",
  "similarityScore": 0,
  "message": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|fileName|string|false|none||原始文件名。|
|duplicateOfMediaId|integer(int64)|false|none||命中的历史媒体ID。|
|duplicateOfTaskId|integer(int64)|false|none||命中的历史任务ID。|
|duplicateOfPenId|integer(int64)|false|none||命中的历史栏舍ID。|
|existingPicturePath|string|false|none||命中的历史媒体访问地址。|
|existingCaptureTime|string|false|none||命中的历史采集时间。|
|similarityScore|number|false|none||相似度分数。|
|message|string|false|none||重复提示信息。|

<h2 id="tocS_Organization">Organization</h2>

<a id="schemaorganization"></a>
<a id="schema_Organization"></a>
<a id="tocSorganization"></a>
<a id="tocsorganization"></a>

```json
{
  "id": 0,
  "orgCode": "string",
  "erpId": "string",
  "orgName": "string",
  "logo": "string",
  "adminName": "string",
  "tel": "string",
  "addr": "string",
  "photoDedupWindowDays": 1,
  "source": "string",
  "enabled": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||组织ID。|
|orgCode|string|true|none||猪场组织编码。|
|erpId|string|false|none||ERP组织ID。|
|orgName|string|true|none||猪场组织名称。|
|logo|string|false|none||组织Logo对象Key。|
|adminName|string|true|none||组织负责人。|
|tel|string|false|none||联系电话。|
|addr|string|false|none||联系地址。|
|photoDedupWindowDays|integer|false|none||图片去重天数窗口。|
|source|string|false|none||数据来源。|
|enabled|boolean|false|none||是否启用。|

<h2 id="tocS_Pen">Pen</h2>

<a id="schemapen"></a>
<a id="schema_Pen"></a>
<a id="tocSpen"></a>
<a id="tocspen"></a>

```json
{
  "id": 0,
  "buildingId": 0,
  "penCode": "string",
  "erpId": "string",
  "penName": "string",
  "source": "string",
  "enabled": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||栏舍ID。|
|buildingId|integer(int64)|true|none||所属楼栋ID。|
|penCode|string|true|none||栏舍编码。|
|erpId|string|false|none||ERP栏舍ID。|
|penName|string|true|none||栏舍名称。|
|source|string|false|none||数据来源。|
|enabled|boolean|false|none||是否启用。|

<h2 id="tocS_TaskPenDTO">TaskPenDTO</h2>

<a id="schemataskpendto"></a>
<a id="schema_TaskPenDTO"></a>
<a id="tocStaskpendto"></a>
<a id="tocstaskpendto"></a>

```json
{
  "penId": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|penId|integer(int64)|false|none||栏舍ID。|

<h2 id="tocS_BuildingCreateDTO">BuildingCreateDTO</h2>

<a id="schemabuildingcreatedto"></a>
<a id="schema_BuildingCreateDTO"></a>
<a id="tocSbuildingcreatedto"></a>
<a id="tocsbuildingcreatedto"></a>

```json
{
  "buildingCode": "string",
  "buildingName": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|buildingCode|string|true|none||楼栋编码。|
|buildingName|string|true|none||楼栋名称。|

<h2 id="tocS_PenCreateDTO">PenCreateDTO</h2>

<a id="schemapencreatedto"></a>
<a id="schema_PenCreateDTO"></a>
<a id="tocSpencreatedto"></a>
<a id="tocspencreatedto"></a>

```json
{
  "buildingId": 0,
  "penCode": "string",
  "penName": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|buildingId|integer(int64)|true|none||所属楼栋ID。|
|penCode|string|true|none||栏舍编码。|
|penName|string|true|none||栏舍名称。|

<h2 id="tocS_OrganizationCreateDTO">OrganizationCreateDTO</h2>

<a id="schemaorganizationcreatedto"></a>
<a id="schema_OrganizationCreateDTO"></a>
<a id="tocSorganizationcreatedto"></a>
<a id="tocsorganizationcreatedto"></a>

```json
{
  "orgCode": "string",
  "orgName": "string",
  "logo": "string",
  "adminName": "string",
  "tel": "string",
  "addr": "string",
  "photoDedupWindowDays": 1
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|orgCode|string|true|none||组织编码。|
|orgName|string|true|none||组织名称。|
|logo|string|false|none||组织Logo对象Key。|
|adminName|string|true|none||组织负责人。|
|tel|string|false|none||联系电话。|
|addr|string|false|none||联系地址。|
|photoDedupWindowDays|integer|false|none||图片去重天数窗口。|

<h2 id="tocS_ResultMapObject">ResultMapObject</h2>

<a id="schemaresultmapobject"></a>
<a id="schema_ResultMapObject"></a>
<a id="tocSresultmapobject"></a>
<a id="tocsresultmapobject"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "key": {}
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[MapObject](#schemamapobject)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_List">List</h2>

<a id="schemalist"></a>
<a id="schema_List"></a>
<a id="tocSlist"></a>
<a id="tocslist"></a>

```json
{}

```

### 属性

*None*

<h2 id="tocS_EmployeeLoginDTO">EmployeeLoginDTO</h2>

<a id="schemaemployeelogindto"></a>
<a id="schema_EmployeeLoginDTO"></a>
<a id="tocSemployeelogindto"></a>
<a id="tocsemployeelogindto"></a>

```json
{
  "username": "string",
  "password": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|username|string|false|none||登录用户名。|
|password|string|false|none||登录密码。|

<h2 id="tocS_InventoryMediaUploadResultVO">InventoryMediaUploadResultVO</h2>

<a id="schemainventorymediauploadresultvo"></a>
<a id="schema_InventoryMediaUploadResultVO"></a>
<a id="tocSinventorymediauploadresultvo"></a>
<a id="tocsinventorymediauploadresultvo"></a>

```json
{
  "taskId": 0,
  "createdItems": [
    {
      "mediaId": 0,
      "taskId": 0,
      "penId": 0,
      "mediaType": "string",
      "picturePath": "string",
      "outputPicturePath": "string",
      "thumbnailPath": "string",
      "count": 0,
      "processingStatus": "string",
      "processingMessage": "string",
      "captureTime": "string"
    }
  ],
  "duplicateItems": [
    {
      "fileName": "string",
      "duplicateOfMediaId": 0,
      "duplicateOfTaskId": 0,
      "duplicateOfPenId": 0,
      "existingPicturePath": "string",
      "existingCaptureTime": "string",
      "similarityScore": 0,
      "message": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|taskId|integer(int64)|false|none||任务ID。|
|createdItems|[[InventoryMediaItemVO](#schemainventorymediaitemvo)]|false|none||成功入库的媒体列表。|
|duplicateItems|[[DuplicateMediaItemVO](#schemaduplicatemediaitemvo)]|false|none||被拒绝的重复媒体列表。|

<h2 id="tocS_TaskBuildingDTO">TaskBuildingDTO</h2>

<a id="schemataskbuildingdto"></a>
<a id="schema_TaskBuildingDTO"></a>
<a id="tocStaskbuildingdto"></a>
<a id="tocstaskbuildingdto"></a>

```json
{
  "buildingId": 0,
  "pens": [
    {
      "penId": 0
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|buildingId|integer(int64)|false|none||楼栋ID。|
|pens|[[TaskPenDTO](#schemataskpendto)]|false|none||栏舍列表。|

<h2 id="tocS_BuildingVO">BuildingVO</h2>

<a id="schemabuildingvo"></a>
<a id="schema_BuildingVO"></a>
<a id="tocSbuildingvo"></a>
<a id="tocsbuildingvo"></a>

```json
{
  "id": 0,
  "buildingCode": "string",
  "buildingName": "string",
  "orgName": "string",
  "orgCode": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||楼栋ID。|
|buildingCode|string|false|none||楼栋编码。|
|buildingName|string|false|none||楼栋名称。|
|orgName|string|false|none||组织名称。|
|orgCode|string|false|none||组织编码。|

<h2 id="tocS_PageResultOrganization">PageResultOrganization</h2>

<a id="schemapageresultorganization"></a>
<a id="schema_PageResultOrganization"></a>
<a id="tocSpageresultorganization"></a>
<a id="tocspageresultorganization"></a>

```json
{
  "total": 0,
  "list": [
    {
      "id": 0,
      "orgCode": "string",
      "erpId": "string",
      "orgName": "string",
      "logo": "string",
      "adminName": "string",
      "tel": "string",
      "addr": "string",
      "photoDedupWindowDays": 1,
      "source": "string",
      "enabled": true
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|total|integer(int64)|false|none||总记录数。|
|list|[[Organization](#schemaorganization)]|false|none||当前页数据。|

<h2 id="tocS_PenVO">PenVO</h2>

<a id="schemapenvo"></a>
<a id="schema_PenVO"></a>
<a id="tocSpenvo"></a>
<a id="tocspenvo"></a>

```json
{
  "id": 0,
  "penCode": "string",
  "penName": "string",
  "buildingCode": "string",
  "buildingName": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||栏舍ID。|
|penCode|string|false|none||栏舍编码。|
|penName|string|false|none||栏舍名称。|
|buildingCode|string|false|none||所属楼栋编码。|
|buildingName|string|false|none||所属楼栋名称。|

<h2 id="tocS_OrganizationUpdateDTO">OrganizationUpdateDTO</h2>

<a id="schemaorganizationupdatedto"></a>
<a id="schema_OrganizationUpdateDTO"></a>
<a id="tocSorganizationupdatedto"></a>
<a id="tocsorganizationupdatedto"></a>

```json
{
  "id": 0,
  "orgCode": "string",
  "orgName": "string",
  "logo": "string",
  "adminName": "string",
  "tel": "string",
  "addr": "string",
  "photoDedupWindowDays": 1
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|true|none||组织ID。|
|orgCode|string|true|none||组织编码。|
|orgName|string|true|none||组织名称。|
|logo|string|false|none||组织Logo对象Key。|
|adminName|string|true|none||组织负责人。|
|tel|string|false|none||联系电话。|
|addr|string|false|none||联系地址。|
|photoDedupWindowDays|integer|false|none||图片去重天数窗口。|

<h2 id="tocS_PageResult">PageResult</h2>

<a id="schemapageresult"></a>
<a id="schema_PageResult"></a>
<a id="tocSpageresult"></a>
<a id="tocspageresult"></a>

```json
{
  "total": 0,
  "list": [
    {}
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|total|integer(int64)|false|none||none|
|list|[[List](#schemalist)]|false|none||none|

<h2 id="tocS_MonoResultInventoryMediaUploadResultVO">MonoResultInventoryMediaUploadResultVO</h2>

<a id="schemamonoresultinventorymediauploadresultvo"></a>
<a id="schema_MonoResultInventoryMediaUploadResultVO"></a>
<a id="tocSmonoresultinventorymediauploadresultvo"></a>
<a id="tocsmonoresultinventorymediauploadresultvo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "taskId": 0,
    "createdItems": [
      {
        "mediaId": 0,
        "taskId": 0,
        "penId": 0,
        "mediaType": "string",
        "picturePath": "string",
        "outputPicturePath": "string",
        "thumbnailPath": "string",
        "count": 0,
        "processingStatus": "string",
        "processingMessage": "string",
        "captureTime": "string"
      }
    ],
    "duplicateItems": [
      {
        "fileName": "string",
        "duplicateOfMediaId": 0,
        "duplicateOfTaskId": 0,
        "duplicateOfPenId": 0,
        "existingPicturePath": "string",
        "existingCaptureTime": "string",
        "similarityScore": 0,
        "message": "string"
      }
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[InventoryMediaUploadResultVO](#schemainventorymediauploadresultvo)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_TaskDTO">TaskDTO</h2>

<a id="schemataskdto"></a>
<a id="schema_TaskDTO"></a>
<a id="tocStaskdto"></a>
<a id="tocstaskdto"></a>

```json
{
  "id": 0,
  "employeeId": 0,
  "taskName": "string",
  "startTime": "string",
  "endTime": "string",
  "buildings": [
    {
      "buildingId": 0,
      "pens": [
        {
          "penId": 0
        }
      ]
    }
  ],
  "orgId": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||任务ID。|
|employeeId|integer(int64)|true|none||执行员工ID。|
|taskName|string|true|none||任务名称。|
|startTime|string|true|none||开始时间。|
|endTime|string|true|none||结束时间。|
|buildings|[[TaskBuildingDTO](#schemataskbuildingdto)]|true|none||任务包含的楼栋和栏舍。|
|orgId|integer(int64)|false|none||组织ID。|

<h2 id="tocS_PageResultBuildingVO">PageResultBuildingVO</h2>

<a id="schemapageresultbuildingvo"></a>
<a id="schema_PageResultBuildingVO"></a>
<a id="tocSpageresultbuildingvo"></a>
<a id="tocspageresultbuildingvo"></a>

```json
{
  "total": 0,
  "list": [
    {
      "id": 0,
      "buildingCode": "string",
      "buildingName": "string",
      "orgName": "string",
      "orgCode": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|total|integer(int64)|false|none||总记录数。|
|list|[[BuildingVO](#schemabuildingvo)]|false|none||当前页数据。|

<h2 id="tocS_ResultPageResultOrganization">ResultPageResultOrganization</h2>

<a id="schemaresultpageresultorganization"></a>
<a id="schema_ResultPageResultOrganization"></a>
<a id="tocSresultpageresultorganization"></a>
<a id="tocsresultpageresultorganization"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "orgCode": "string",
        "erpId": "string",
        "orgName": "string",
        "logo": "string",
        "adminName": "string",
        "tel": "string",
        "addr": "string",
        "photoDedupWindowDays": 1,
        "source": "string",
        "enabled": true
      }
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[PageResultOrganization](#schemapageresultorganization)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_PageResultPenVO">PageResultPenVO</h2>

<a id="schemapageresultpenvo"></a>
<a id="schema_PageResultPenVO"></a>
<a id="tocSpageresultpenvo"></a>
<a id="tocspageresultpenvo"></a>

```json
{
  "total": 0,
  "list": [
    {
      "id": 0,
      "penCode": "string",
      "penName": "string",
      "buildingCode": "string",
      "buildingName": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|total|integer(int64)|false|none||总记录数。|
|list|[[PenVO](#schemapenvo)]|false|none||当前页数据。|

<h2 id="tocS_ResultPageResult">ResultPageResult</h2>

<a id="schemaresultpageresult"></a>
<a id="schema_ResultPageResult"></a>
<a id="tocSresultpageresult"></a>
<a id="tocsresultpageresult"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "total": 0,
    "list": [
      {}
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[PageResult](#schemapageresult)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_ResultPageResultBuildingVO">ResultPageResultBuildingVO</h2>

<a id="schemaresultpageresultbuildingvo"></a>
<a id="schema_ResultPageResultBuildingVO"></a>
<a id="tocSresultpageresultbuildingvo"></a>
<a id="tocsresultpageresultbuildingvo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "buildingCode": "string",
        "buildingName": "string",
        "orgName": "string",
        "orgCode": "string"
      }
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[PageResultBuildingVO](#schemapageresultbuildingvo)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_PageResultString">PageResultString</h2>

<a id="schemapageresultstring"></a>
<a id="schema_PageResultString"></a>
<a id="tocSpageresultstring"></a>
<a id="tocspageresultstring"></a>

```json
{
  "total": 0,
  "list": [
    "string"
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|total|integer(int64)|false|none||总记录数。|
|list|[string]|false|none||当前页数据。|

<h2 id="tocS_ResultPageResultPenVO">ResultPageResultPenVO</h2>

<a id="schemaresultpageresultpenvo"></a>
<a id="schema_ResultPageResultPenVO"></a>
<a id="tocSresultpageresultpenvo"></a>
<a id="tocsresultpageresultpenvo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "penCode": "string",
        "penName": "string",
        "buildingCode": "string",
        "buildingName": "string"
      }
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[PageResultPenVO](#schemapageresultpenvo)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_Task">Task</h2>

<a id="schematask"></a>
<a id="schema_Task"></a>
<a id="tocStask"></a>
<a id="tocstask"></a>

```json
{
  "id": 0,
  "taskName": "string",
  "employeeId": 0,
  "startTime": "string",
  "endTime": "string",
  "valid": true,
  "orgId": 0,
  "taskStatus": "string",
  "issuedBy": 0,
  "issuedAt": "string",
  "receivedAt": "string",
  "completedAt": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||任务ID。|
|taskName|string|false|none||任务名称。|
|employeeId|integer(int64)|false|none||执行员工ID。|
|startTime|string|false|none||开始时间。|
|endTime|string|false|none||结束时间。|
|valid|boolean|false|none||是否有效。|
|orgId|integer(int64)|false|none||所属组织ID。|
|taskStatus|string|false|none||任务状态。|
|issuedBy|integer(int64)|false|none||下发人ID。|
|issuedAt|string|false|none||下发时间。|
|receivedAt|string|false|none||接收时间。|
|completedAt|string|false|none||完成时间。|

<h2 id="tocS_OrgPenVO">OrgPenVO</h2>

<a id="schemaorgpenvo"></a>
<a id="schema_OrgPenVO"></a>
<a id="tocSorgpenvo"></a>
<a id="tocsorgpenvo"></a>

```json
{
  "id": 0,
  "code": "string",
  "name": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||栏舍ID。|
|code|string|false|none||栏舍编码。|
|name|string|false|none||栏舍名称。|

<h2 id="tocS_InventoryMediaBindDTO">InventoryMediaBindDTO</h2>

<a id="schemainventorymediabinddto"></a>
<a id="schema_InventoryMediaBindDTO"></a>
<a id="tocSinventorymediabinddto"></a>
<a id="tocsinventorymediabinddto"></a>

```json
{
  "penId": 0,
  "mediaIds": [
    0
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|penId|integer(int64)|true|none||栏舍ID。|
|mediaIds|[integer]|true|none||媒体ID列表。|

<h2 id="tocS_PageResultEmployee">PageResultEmployee</h2>

<a id="schemapageresultemployee"></a>
<a id="schema_PageResultEmployee"></a>
<a id="tocSpageresultemployee"></a>
<a id="tocspageresultemployee"></a>

```json
{
  "total": 0,
  "list": [
    {
      "id": 0,
      "username": "string",
      "password": "string",
      "name": "string",
      "sex": "string",
      "phone": "string",
      "createTime": "string",
      "profilePicture": "string",
      "organization": "string",
      "admin": true,
      "orgId": 0
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|total|integer(int64)|false|none||总记录数。|
|list|[[Employee](#schemaemployee)]|false|none||当前页数据。|

<h2 id="tocS_ResultPageResultString">ResultPageResultString</h2>

<a id="schemaresultpageresultstring"></a>
<a id="schema_ResultPageResultString"></a>
<a id="tocSresultpageresultstring"></a>
<a id="tocsresultpageresultstring"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "total": 0,
    "list": [
      "string"
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[PageResultString](#schemapageresultstring)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_PageResultTask">PageResultTask</h2>

<a id="schemapageresulttask"></a>
<a id="schema_PageResultTask"></a>
<a id="tocSpageresulttask"></a>
<a id="tocspageresulttask"></a>

```json
{
  "total": 0,
  "list": [
    {
      "id": 0,
      "taskName": "string",
      "employeeId": 0,
      "startTime": "string",
      "endTime": "string",
      "valid": true,
      "orgId": 0,
      "taskStatus": "string",
      "issuedBy": 0,
      "issuedAt": "string",
      "receivedAt": "string",
      "completedAt": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|total|integer(int64)|false|none||总记录数。|
|list|[[Task](#schematask)]|false|none||当前页数据。|

<h2 id="tocS_PenInventoryStatVO">PenInventoryStatVO</h2>

<a id="schemapeninventorystatvo"></a>
<a id="schema_PenInventoryStatVO"></a>
<a id="tocSpeninventorystatvo"></a>
<a id="tocspeninventorystatvo"></a>

```json
{
  "sampleSize": 0,
  "avgCount": 0,
  "minCount": 0,
  "maxCount": 0,
  "finalCount": 0,
  "deadPigQuantity": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|sampleSize|integer|false|none||样本数量。|
|avgCount|number|false|none||平均数量。|
|minCount|integer|false|none||最小数量。|
|maxCount|integer|false|none||最大数量。|
|finalCount|integer|false|none||建议数量。|
|deadPigQuantity|integer|false|none||死猪数量。|

<h2 id="tocS_BuildingUpdateDTO">BuildingUpdateDTO</h2>

<a id="schemabuildingupdatedto"></a>
<a id="schema_BuildingUpdateDTO"></a>
<a id="tocSbuildingupdatedto"></a>
<a id="tocsbuildingupdatedto"></a>

```json
{
  "id": 0,
  "buildingCode": "string",
  "buildingName": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|true|none||楼栋ID。|
|buildingCode|string|true|none||楼栋编码。|
|buildingName|string|true|none||楼栋名称。|

<h2 id="tocS_OrgBuildingVO">OrgBuildingVO</h2>

<a id="schemaorgbuildingvo"></a>
<a id="schema_OrgBuildingVO"></a>
<a id="tocSorgbuildingvo"></a>
<a id="tocsorgbuildingvo"></a>

```json
{
  "id": 0,
  "code": "string",
  "name": "string",
  "pens": [
    {
      "id": 0,
      "code": "string",
      "name": "string"
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||楼栋ID。|
|code|string|false|none||楼栋编码。|
|name|string|false|none||楼栋名称。|
|pens|[[OrgPenVO](#schemaorgpenvo)]|false|none||栏舍列表。|

<h2 id="tocS_PenMediaVO">PenMediaVO</h2>

<a id="schemapenmediavo"></a>
<a id="schema_PenMediaVO"></a>
<a id="tocSpenmediavo"></a>
<a id="tocspenmediavo"></a>

```json
{
  "id": 0,
  "taskId": 0,
  "orgId": 0,
  "penId": 0,
  "mediaType": "string",
  "picturePath": "string",
  "outputPicturePath": "string",
  "thumbnailPath": "string",
  "time": "string",
  "captureTime": "string",
  "dayBucket": "string",
  "count": 0,
  "manualCount": 0,
  "processingStatus": "string",
  "processingMessage": "string",
  "status": true,
  "duplicate": true,
  "analysisJson": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||媒体ID。|
|taskId|integer(int64)|false|none||任务ID。|
|orgId|integer(int64)|false|none||组织ID。|
|penId|integer(int64)|false|none||栏舍ID。|
|mediaType|string|false|none||媒体类型。|
|picturePath|string|false|none||原始媒体访问地址。|
|outputPicturePath|string|false|none||输出媒体访问地址。|
|thumbnailPath|string|false|none||预览缩略图访问地址。|
|time|string|false|none||上传时间。|
|captureTime|string|false|none||采集时间。|
|dayBucket|string|false|none||自然日分桶。|
|count|integer|false|none||模型盘点数量。|
|manualCount|integer|false|none||人工修正数量。|
|processingStatus|string|false|none||媒体处理状态。|
|processingMessage|string|false|none||媒体处理提示。|
|status|boolean|false|none||是否已确认。|
|duplicate|boolean|false|none||是否重复媒体。|
|analysisJson|string|false|none||分析结果JSON。|

<h2 id="tocS_ResultPageResultEmployee">ResultPageResultEmployee</h2>

<a id="schemaresultpageresultemployee"></a>
<a id="schema_ResultPageResultEmployee"></a>
<a id="tocSresultpageresultemployee"></a>
<a id="tocsresultpageresultemployee"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "username": "string",
        "password": "string",
        "name": "string",
        "sex": "string",
        "phone": "string",
        "createTime": "string",
        "profilePicture": "string",
        "organization": "string",
        "admin": true,
        "orgId": 0
      }
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[PageResultEmployee](#schemapageresultemployee)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_ResultPageResultTask">ResultPageResultTask</h2>

<a id="schemaresultpageresulttask"></a>
<a id="schema_ResultPageResultTask"></a>
<a id="tocSresultpageresulttask"></a>
<a id="tocsresultpageresulttask"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "total": 0,
    "list": [
      {
        "id": 0,
        "taskName": "string",
        "employeeId": 0,
        "startTime": "string",
        "endTime": "string",
        "valid": true,
        "orgId": 0,
        "taskStatus": "string",
        "issuedBy": 0,
        "issuedAt": "string",
        "receivedAt": "string",
        "completedAt": "string"
      }
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[PageResultTask](#schemapageresulttask)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_PenInventoryMediaSummaryVO">PenInventoryMediaSummaryVO</h2>

<a id="schemapeninventorymediasummaryvo"></a>
<a id="schema_PenInventoryMediaSummaryVO"></a>
<a id="tocSpeninventorymediasummaryvo"></a>
<a id="tocspeninventorymediasummaryvo"></a>

```json
{
  "totalMediaCount": 0,
  "imageMediaCount": 0,
  "videoMediaCount": 0,
  "confirmedMediaCount": 0,
  "unconfirmedMediaCount": 0,
  "pendingMediaCount": 0,
  "processingMediaCount": 0,
  "successMediaCount": 0,
  "failedMediaCount": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|totalMediaCount|integer|false|none||当日媒体总数。|
|imageMediaCount|integer|false|none||当日图片数量。|
|videoMediaCount|integer|false|none||当日视频数量。|
|confirmedMediaCount|integer|false|none||当日已确认媒体数量。|
|unconfirmedMediaCount|integer|false|none||当日未确认媒体数量。|
|pendingMediaCount|integer|false|none||当日待处理媒体数量。|
|processingMediaCount|integer|false|none||当日处理中媒体数量。|
|successMediaCount|integer|false|none||当日处理成功媒体数量。|
|failedMediaCount|integer|false|none||当日处理失败媒体数量。|

<h2 id="tocS_OrgBuildingAndPenVO">OrgBuildingAndPenVO</h2>

<a id="schemaorgbuildingandpenvo"></a>
<a id="schema_OrgBuildingAndPenVO"></a>
<a id="tocSorgbuildingandpenvo"></a>
<a id="tocsorgbuildingandpenvo"></a>

```json
{
  "orgId": 0,
  "buildings": [
    {
      "id": 0,
      "code": "string",
      "name": "string",
      "pens": [
        {
          "id": 0,
          "code": "string",
          "name": "string"
        }
      ]
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|orgId|integer(int64)|false|none||组织ID。|
|buildings|[[OrgBuildingVO](#schemaorgbuildingvo)]|false|none||楼栋列表。|

<h2 id="tocS_Employee">Employee</h2>

<a id="schemaemployee"></a>
<a id="schema_Employee"></a>
<a id="tocSemployee"></a>
<a id="tocsemployee"></a>

```json
{
  "id": 0,
  "username": "string",
  "password": "string",
  "name": "string",
  "sex": "string",
  "phone": "string",
  "createTime": "string",
  "profilePicture": "string",
  "organization": "string",
  "admin": true,
  "orgId": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||员工ID。|
|username|string|false|none||登录用户名。|
|password|string|false|none||登录密码。|
|name|string|false|none||员工姓名。|
|sex|string|false|none||性别。|
|phone|string|false|none||手机号。|
|createTime|string|false|none||创建时间。|
|profilePicture|string|false|none||头像对象Key。|
|organization|string|false|none||组织名称。|
|admin|boolean|false|none||是否管理员。|
|orgId|integer(int64)|false|none||所属组织ID。|

<h2 id="tocS_ResultListPenMediaVO">ResultListPenMediaVO</h2>

<a id="schemaresultlistpenmediavo"></a>
<a id="schema_ResultListPenMediaVO"></a>
<a id="tocSresultlistpenmediavo"></a>
<a id="tocsresultlistpenmediavo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": [
    {
      "id": 0,
      "taskId": 0,
      "orgId": 0,
      "penId": 0,
      "mediaType": "string",
      "picturePath": "string",
      "outputPicturePath": "string",
      "thumbnailPath": "string",
      "time": "string",
      "captureTime": "string",
      "dayBucket": "string",
      "count": 0,
      "manualCount": 0,
      "processingStatus": "string",
      "processingMessage": "string",
      "status": true,
      "duplicate": true,
      "analysisJson": "string"
    }
  ],
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[[PenMediaVO](#schemapenmediavo)]|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_DetailPenDTO">DetailPenDTO</h2>

<a id="schemadetailpendto"></a>
<a id="schema_DetailPenDTO"></a>
<a id="tocSdetailpendto"></a>
<a id="tocsdetailpendto"></a>

```json
{
  "penId": 0,
  "penName": "string",
  "mediaType": "string",
  "count": 0,
  "picturePath": "string",
  "outputPicturePath": "string",
  "thumbnailPath": "string",
  "manualCount": 0,
  "processingStatus": "string",
  "processingMessage": "string",
  "status": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|penId|integer(int64)|false|none||栏舍ID。|
|penName|string|false|none||栏舍名称。|
|mediaType|string|false|none||媒体类型。|
|count|integer|false|none||模型盘点数量。|
|picturePath|string|false|none||原始媒体地址。|
|outputPicturePath|string|false|none||输出媒体地址。|
|thumbnailPath|string|false|none||预览缩略图地址。|
|manualCount|integer|false|none||人工修正数量。|
|processingStatus|string|false|none||媒体处理状态。|
|processingMessage|string|false|none||媒体处理提示。|
|status|boolean|false|none||是否已确认。|

<h2 id="tocS_ResultOrgBuildingAndPenVO">ResultOrgBuildingAndPenVO</h2>

<a id="schemaresultorgbuildingandpenvo"></a>
<a id="schema_ResultOrgBuildingAndPenVO"></a>
<a id="tocSresultorgbuildingandpenvo"></a>
<a id="tocsresultorgbuildingandpenvo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "orgId": 0,
    "buildings": [
      {
        "id": 0,
        "code": "string",
        "name": "string",
        "pens": [
          {
            "id": null,
            "code": null,
            "name": null
          }
        ]
      }
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[OrgBuildingAndPenVO](#schemaorgbuildingandpenvo)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_ResultEmployee">ResultEmployee</h2>

<a id="schemaresultemployee"></a>
<a id="schema_ResultEmployee"></a>
<a id="tocSresultemployee"></a>
<a id="tocsresultemployee"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "id": 0,
    "username": "string",
    "password": "string",
    "name": "string",
    "sex": "string",
    "phone": "string",
    "createTime": "string",
    "profilePicture": "string",
    "organization": "string",
    "admin": true,
    "orgId": 0
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[Employee](#schemaemployee)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_ConfirmPenPictureDTO">ConfirmPenPictureDTO</h2>

<a id="schemaconfirmpenpicturedto"></a>
<a id="schema_ConfirmPenPictureDTO"></a>
<a id="tocSconfirmpenpicturedto"></a>
<a id="tocsconfirmpenpicturedto"></a>

```json
{
  "mediaIds": [
    0
  ],
  "status": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|mediaIds|[integer]|false|none||媒体ID列表。|
|status|boolean|false|none||是否确认。|

<h2 id="tocS_DetailBuildingDTO">DetailBuildingDTO</h2>

<a id="schemadetailbuildingdto"></a>
<a id="schema_DetailBuildingDTO"></a>
<a id="tocSdetailbuildingdto"></a>
<a id="tocsdetailbuildingdto"></a>

```json
{
  "buildingId": 0,
  "buildingName": "string",
  "pens": [
    {
      "penId": 0,
      "penName": "string",
      "mediaType": "string",
      "count": 0,
      "picturePath": "string",
      "outputPicturePath": "string",
      "thumbnailPath": "string",
      "manualCount": 0,
      "processingStatus": "string",
      "processingMessage": "string",
      "status": true
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|buildingId|integer(int64)|false|none||楼栋ID。|
|buildingName|string|false|none||楼栋名称。|
|pens|[[DetailPenDTO](#schemadetailpendto)]|false|none||栏舍列表。|

<h2 id="tocS_PenInventoryTrendVO">PenInventoryTrendVO</h2>

<a id="schemapeninventorytrendvo"></a>
<a id="schema_PenInventoryTrendVO"></a>
<a id="tocSpeninventorytrendvo"></a>
<a id="tocspeninventorytrendvo"></a>

```json
{
  "statDate": "string",
  "sampleSize": 0,
  "avgCount": 0,
  "minCount": 0,
  "maxCount": 0,
  "finalCount": 0,
  "deadPigQuantity": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|statDate|string|false|none||统计日期。|
|sampleSize|integer|false|none||样本数量。|
|avgCount|number|false|none||平均数量。|
|minCount|integer|false|none||最小数量。|
|maxCount|integer|false|none||最大数量。|
|finalCount|integer|false|none||建议数量。|
|deadPigQuantity|integer|false|none||死猪数量。|

<h2 id="tocS_ManualCountUpdateDTO">ManualCountUpdateDTO</h2>

<a id="schemamanualcountupdatedto"></a>
<a id="schema_ManualCountUpdateDTO"></a>
<a id="tocSmanualcountupdatedto"></a>
<a id="tocsmanualcountupdatedto"></a>

```json
{
  "mediaId": 0,
  "manualCount": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|mediaId|integer(int64)|true|none||媒体ID。|
|manualCount|integer|true|none||人工盘点数量。|

<h2 id="tocS_DetailTaskDTO">DetailTaskDTO</h2>

<a id="schemadetailtaskdto"></a>
<a id="schema_DetailTaskDTO"></a>
<a id="tocSdetailtaskdto"></a>
<a id="tocsdetailtaskdto"></a>

```json
{
  "id": 0,
  "employeeId": 0,
  "taskName": "string",
  "startTime": "string",
  "endTime": "string",
  "orgId": 0,
  "taskStatus": "string",
  "issuedAt": "string",
  "receivedAt": "string",
  "completedAt": "string",
  "assignedPenCount": 0,
  "uploadedPenCount": 0,
  "confirmedPenCount": 0,
  "processingPenCount": 0,
  "failedPenCount": 0,
  "unboundMediaCount": 0,
  "buildings": [
    {
      "buildingId": 0,
      "buildingName": "string",
      "pens": [
        {
          "penId": 0,
          "penName": "string",
          "mediaType": "string",
          "count": 0,
          "picturePath": "string",
          "outputPicturePath": "string",
          "thumbnailPath": "string",
          "manualCount": 0,
          "processingStatus": "string",
          "processingMessage": "string",
          "status": true
        }
      ]
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||任务ID。|
|employeeId|integer(int64)|false|none||执行员工ID。|
|taskName|string|false|none||任务名称。|
|startTime|string|false|none||开始时间。|
|endTime|string|false|none||结束时间。|
|orgId|integer(int64)|false|none||所属组织ID。|
|taskStatus|string|false|none||任务状态。|
|issuedAt|string|false|none||下发时间。|
|receivedAt|string|false|none||接收时间。|
|completedAt|string|false|none||完成时间。|
|assignedPenCount|integer|false|none||分配栏舍数量。|
|uploadedPenCount|integer|false|none||已上传栏舍数量。|
|confirmedPenCount|integer|false|none||已确认栏舍数量。|
|processingPenCount|integer|false|none||处理中栏舍数量。|
|failedPenCount|integer|false|none||处理失败栏舍数量。|
|unboundMediaCount|integer|false|none||未绑定媒体数量。|
|buildings|[[DetailBuildingDTO](#schemadetailbuildingdto)]|false|none||楼栋详情列表。|

<h2 id="tocS_PenInventoryOverviewVO">PenInventoryOverviewVO</h2>

<a id="schemapeninventoryoverviewvo"></a>
<a id="schema_PenInventoryOverviewVO"></a>
<a id="tocSpeninventoryoverviewvo"></a>
<a id="tocspeninventoryoverviewvo"></a>

```json
{
  "orgId": 0,
  "orgName": "string",
  "buildingId": 0,
  "buildingName": "string",
  "penId": 0,
  "penCode": "string",
  "penName": "string",
  "focusDate": "string",
  "trendStartDate": "string",
  "trendEndDate": "string",
  "todayLiveStat": {
    "sampleSize": 0,
    "avgCount": 0,
    "minCount": 0,
    "maxCount": 0,
    "finalCount": 0,
    "deadPigQuantity": 0
  },
  "todayConfirmedStat": {
    "sampleSize": 0,
    "avgCount": 0,
    "minCount": 0,
    "maxCount": 0,
    "finalCount": 0,
    "deadPigQuantity": 0
  },
  "todayMediaSummary": {
    "totalMediaCount": 0,
    "imageMediaCount": 0,
    "videoMediaCount": 0,
    "confirmedMediaCount": 0,
    "unconfirmedMediaCount": 0,
    "pendingMediaCount": 0,
    "processingMediaCount": 0,
    "successMediaCount": 0,
    "failedMediaCount": 0
  },
  "latestMedia": {
    "id": 0,
    "taskId": 0,
    "orgId": 0,
    "penId": 0,
    "mediaType": "string",
    "picturePath": "string",
    "outputPicturePath": "string",
    "thumbnailPath": "string",
    "time": "string",
    "captureTime": "string",
    "dayBucket": "string",
    "count": 0,
    "manualCount": 0,
    "processingStatus": "string",
    "processingMessage": "string",
    "status": true,
    "duplicate": true,
    "analysisJson": "string"
  },
  "recentMedia": [
    {
      "id": 0,
      "taskId": 0,
      "orgId": 0,
      "penId": 0,
      "mediaType": "string",
      "picturePath": "string",
      "outputPicturePath": "string",
      "thumbnailPath": "string",
      "time": "string",
      "captureTime": "string",
      "dayBucket": "string",
      "count": 0,
      "manualCount": 0,
      "processingStatus": "string",
      "processingMessage": "string",
      "status": true,
      "duplicate": true,
      "analysisJson": "string"
    }
  ],
  "confirmedTrend": [
    {
      "statDate": "string",
      "sampleSize": 0,
      "avgCount": 0,
      "minCount": 0,
      "maxCount": 0,
      "finalCount": 0,
      "deadPigQuantity": 0
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|orgId|integer(int64)|false|none||组织ID。|
|orgName|string|false|none||组织名称。|
|buildingId|integer(int64)|false|none||楼栋ID。|
|buildingName|string|false|none||楼栋名称。|
|penId|integer(int64)|false|none||栏舍ID。|
|penCode|string|false|none||栏舍编码。|
|penName|string|false|none||栏舍名称。|
|focusDate|string|false|none||当前聚焦日期。|
|trendStartDate|string|false|none||趋势开始日期。|
|trendEndDate|string|false|none||趋势结束日期。|
|todayLiveStat|[PenInventoryStatVO](#schemapeninventorystatvo)|false|none||当日实时统计，包含未确认但已成功处理的媒体。|
|todayConfirmedStat|[PenInventoryStatVO](#schemapeninventorystatvo)|false|none||当日正式统计，只包含已确认媒体。|
|todayMediaSummary|[PenInventoryMediaSummaryVO](#schemapeninventorymediasummaryvo)|false|none||当日媒体汇总。|
|latestMedia|[PenMediaVO](#schemapenmediavo)|false|none||当前区间内最新一条媒体。|
|recentMedia|[[PenMediaVO](#schemapenmediavo)]|false|none||当前区间内最近媒体列表。|
|confirmedTrend|[[PenInventoryTrendVO](#schemapeninventorytrendvo)]|false|none||区间内按天汇总的已确认趋势。|

<h2 id="tocS_DailyInventoryPenReportVO">DailyInventoryPenReportVO</h2>

<a id="schemadailyinventorypenreportvo"></a>
<a id="schema_DailyInventoryPenReportVO"></a>
<a id="tocSdailyinventorypenreportvo"></a>
<a id="tocsdailyinventorypenreportvo"></a>

```json
{
  "penId": 0,
  "penName": "string",
  "sampleSize": 0,
  "avgCount": 0,
  "minCount": 0,
  "maxCount": 0,
  "finalCount": 0,
  "deadPigQuantity": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|penId|integer(int64)|false|none||栏舍ID。|
|penName|string|false|none||栏舍名称。|
|sampleSize|integer|false|none||样本数量。|
|avgCount|number|false|none||平均数量。|
|minCount|integer|false|none||最小数量。|
|maxCount|integer|false|none||最大数量。|
|finalCount|integer|false|none||最终建议数量。|
|deadPigQuantity|integer|false|none||当日死猪数量。|

<h2 id="tocS_ResultDetailTaskDTO">ResultDetailTaskDTO</h2>

<a id="schemaresultdetailtaskdto"></a>
<a id="schema_ResultDetailTaskDTO"></a>
<a id="tocSresultdetailtaskdto"></a>
<a id="tocsresultdetailtaskdto"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "id": 0,
    "employeeId": 0,
    "taskName": "string",
    "startTime": "string",
    "endTime": "string",
    "orgId": 0,
    "taskStatus": "string",
    "issuedAt": "string",
    "receivedAt": "string",
    "completedAt": "string",
    "assignedPenCount": 0,
    "uploadedPenCount": 0,
    "confirmedPenCount": 0,
    "processingPenCount": 0,
    "failedPenCount": 0,
    "unboundMediaCount": 0,
    "buildings": [
      {
        "buildingId": 0,
        "buildingName": "string",
        "pens": [
          {
            "penId": null,
            "penName": null,
            "mediaType": null,
            "count": null,
            "picturePath": null,
            "outputPicturePath": null,
            "thumbnailPath": null,
            "manualCount": null,
            "processingStatus": null,
            "processingMessage": null,
            "status": null
          }
        ]
      }
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[DetailTaskDTO](#schemadetailtaskdto)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_PenMediaSummaryVO">PenMediaSummaryVO</h2>

<a id="schemapenmediasummaryvo"></a>
<a id="schema_PenMediaSummaryVO"></a>
<a id="tocSpenmediasummaryvo"></a>
<a id="tocspenmediasummaryvo"></a>

```json
{
  "statDate": "string",
  "sampleSize": 0,
  "avgCount": 0,
  "minCount": 0,
  "maxCount": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|statDate|string|false|none||统计日期。|
|sampleSize|integer|false|none||样本数量。|
|avgCount|number|false|none||平均盘点数量。|
|minCount|integer|false|none||最小盘点数量。|
|maxCount|integer|false|none||最大盘点数量。|

<h2 id="tocS_ResultPenInventoryOverviewVO">ResultPenInventoryOverviewVO</h2>

<a id="schemaresultpeninventoryoverviewvo"></a>
<a id="schema_ResultPenInventoryOverviewVO"></a>
<a id="tocSresultpeninventoryoverviewvo"></a>
<a id="tocsresultpeninventoryoverviewvo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "orgId": 0,
    "orgName": "string",
    "buildingId": 0,
    "buildingName": "string",
    "penId": 0,
    "penCode": "string",
    "penName": "string",
    "focusDate": "string",
    "trendStartDate": "string",
    "trendEndDate": "string",
    "todayLiveStat": {
      "sampleSize": 0,
      "avgCount": 0,
      "minCount": 0,
      "maxCount": 0,
      "finalCount": 0,
      "deadPigQuantity": 0
    },
    "todayConfirmedStat": {
      "sampleSize": 0,
      "avgCount": 0,
      "minCount": 0,
      "maxCount": 0,
      "finalCount": 0,
      "deadPigQuantity": 0
    },
    "todayMediaSummary": {
      "totalMediaCount": 0,
      "imageMediaCount": 0,
      "videoMediaCount": 0,
      "confirmedMediaCount": 0,
      "unconfirmedMediaCount": 0,
      "pendingMediaCount": 0,
      "processingMediaCount": 0,
      "successMediaCount": 0,
      "failedMediaCount": 0
    },
    "latestMedia": {
      "id": 0,
      "taskId": 0,
      "orgId": 0,
      "penId": 0,
      "mediaType": "string",
      "picturePath": "string",
      "outputPicturePath": "string",
      "thumbnailPath": "string",
      "time": "string",
      "captureTime": "string",
      "dayBucket": "string",
      "count": 0,
      "manualCount": 0,
      "processingStatus": "string",
      "processingMessage": "string",
      "status": true,
      "duplicate": true,
      "analysisJson": "string"
    },
    "recentMedia": [
      {
        "id": 0,
        "taskId": 0,
        "orgId": 0,
        "penId": 0,
        "mediaType": "string",
        "picturePath": "string",
        "outputPicturePath": "string",
        "thumbnailPath": "string",
        "time": "string",
        "captureTime": "string",
        "dayBucket": "string",
        "count": 0,
        "manualCount": 0,
        "processingStatus": "string",
        "processingMessage": "string",
        "status": true,
        "duplicate": true,
        "analysisJson": "string"
      }
    ],
    "confirmedTrend": [
      {
        "statDate": "string",
        "sampleSize": 0,
        "avgCount": 0,
        "minCount": 0,
        "maxCount": 0,
        "finalCount": 0,
        "deadPigQuantity": 0
      }
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[PenInventoryOverviewVO](#schemapeninventoryoverviewvo)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_DailyInventoryBuildingReportVO">DailyInventoryBuildingReportVO</h2>

<a id="schemadailyinventorybuildingreportvo"></a>
<a id="schema_DailyInventoryBuildingReportVO"></a>
<a id="tocSdailyinventorybuildingreportvo"></a>
<a id="tocsdailyinventorybuildingreportvo"></a>

```json
{
  "buildingId": 0,
  "buildingName": "string",
  "pens": [
    {
      "penId": 0,
      "penName": "string",
      "sampleSize": 0,
      "avgCount": 0,
      "minCount": 0,
      "maxCount": 0,
      "finalCount": 0,
      "deadPigQuantity": 0
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|buildingId|integer(int64)|false|none||楼栋ID。|
|buildingName|string|false|none||楼栋名称。|
|pens|[[DailyInventoryPenReportVO](#schemadailyinventorypenreportvo)]|false|none||栏舍列表。|

<h2 id="tocS_PenPictureVO">PenPictureVO</h2>

<a id="schemapenpicturevo"></a>
<a id="schema_PenPictureVO"></a>
<a id="tocSpenpicturevo"></a>
<a id="tocspenpicturevo"></a>

```json
{
  "picturePath": [
    "string"
  ],
  "outputPicturePath": [
    "string"
  ],
  "taskId": 0,
  "count": [
    0
  ],
  "processingStatus": [
    "string"
  ],
  "processingMessage": [
    "string"
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|picturePath|[string]|false|none||原始媒体地址列表。|
|outputPicturePath|[string]|false|none||输出媒体地址列表。|
|taskId|integer(int64)|false|none||任务ID。|
|count|[integer]|false|none||盘点结果列表。|
|processingStatus|[string]|false|none||处理状态列表。|
|processingMessage|[string]|false|none||处理提示列表。|

<h2 id="tocS_PageResultPenMediaSummaryVO">PageResultPenMediaSummaryVO</h2>

<a id="schemapageresultpenmediasummaryvo"></a>
<a id="schema_PageResultPenMediaSummaryVO"></a>
<a id="tocSpageresultpenmediasummaryvo"></a>
<a id="tocspageresultpenmediasummaryvo"></a>

```json
{
  "total": 0,
  "list": [
    {
      "statDate": "string",
      "sampleSize": 0,
      "avgCount": 0,
      "minCount": 0,
      "maxCount": 0
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|total|integer(int64)|false|none||总记录数。|
|list|[[PenMediaSummaryVO](#schemapenmediasummaryvo)]|false|none||当前页数据。|

<h2 id="tocS_PenUpdateDTO">PenUpdateDTO</h2>

<a id="schemapenupdatedto"></a>
<a id="schema_PenUpdateDTO"></a>
<a id="tocSpenupdatedto"></a>
<a id="tocspenupdatedto"></a>

```json
{
  "id": 0,
  "buildingId": 0,
  "penCode": "string",
  "penName": "string"
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|true|none||栏舍ID。|
|buildingId|integer(int64)|false|none||所属楼栋ID。|
|penCode|string|true|none||栏舍编码。|
|penName|string|true|none||栏舍名称。|

<h2 id="tocS_DailyInventoryReportVO">DailyInventoryReportVO</h2>

<a id="schemadailyinventoryreportvo"></a>
<a id="schema_DailyInventoryReportVO"></a>
<a id="tocSdailyinventoryreportvo"></a>
<a id="tocsdailyinventoryreportvo"></a>

```json
{
  "orgId": 0,
  "orgName": "string",
  "reportDate": "string",
  "buildings": [
    {
      "buildingId": 0,
      "buildingName": "string",
      "pens": [
        {
          "penId": 0,
          "penName": "string",
          "sampleSize": 0,
          "avgCount": 0,
          "minCount": 0,
          "maxCount": 0,
          "finalCount": 0,
          "deadPigQuantity": 0
        }
      ]
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|orgId|integer(int64)|false|none||组织ID。|
|orgName|string|false|none||组织名称。|
|reportDate|string|false|none||报表日期。|
|buildings|[[DailyInventoryBuildingReportVO](#schemadailyinventorybuildingreportvo)]|false|none||楼栋列表。|

<h2 id="tocS_MonoResultPenPictureVO">MonoResultPenPictureVO</h2>

<a id="schemamonoresultpenpicturevo"></a>
<a id="schema_MonoResultPenPictureVO"></a>
<a id="tocSmonoresultpenpicturevo"></a>
<a id="tocsmonoresultpenpicturevo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "picturePath": [
      "string"
    ],
    "outputPicturePath": [
      "string"
    ],
    "taskId": 0,
    "count": [
      0
    ],
    "processingStatus": [
      "string"
    ],
    "processingMessage": [
      "string"
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[PenPictureVO](#schemapenpicturevo)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_ResultPageResultPenMediaSummaryVO">ResultPageResultPenMediaSummaryVO</h2>

<a id="schemaresultpageresultpenmediasummaryvo"></a>
<a id="schema_ResultPageResultPenMediaSummaryVO"></a>
<a id="tocSresultpageresultpenmediasummaryvo"></a>
<a id="tocsresultpageresultpenmediasummaryvo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "total": 0,
    "list": [
      {
        "statDate": "string",
        "sampleSize": 0,
        "avgCount": 0,
        "minCount": 0,
        "maxCount": 0
      }
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[PageResultPenMediaSummaryVO](#schemapageresultpenmediasummaryvo)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_ResultDailyInventoryReportVO">ResultDailyInventoryReportVO</h2>

<a id="schemaresultdailyinventoryreportvo"></a>
<a id="schema_ResultDailyInventoryReportVO"></a>
<a id="tocSresultdailyinventoryreportvo"></a>
<a id="tocsresultdailyinventoryreportvo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "orgId": 0,
    "orgName": "string",
    "reportDate": "string",
    "buildings": [
      {
        "buildingId": 0,
        "buildingName": "string",
        "pens": [
          {
            "penId": null,
            "penName": null,
            "sampleSize": null,
            "avgCount": null,
            "minCount": null,
            "maxCount": null,
            "finalCount": null,
            "deadPigQuantity": null
          }
        ]
      }
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[DailyInventoryReportVO](#schemadailyinventoryreportvo)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_ComprehensiveInventoryDailySnapshotVO">ComprehensiveInventoryDailySnapshotVO</h2>

<a id="schemacomprehensiveinventorydailysnapshotvo"></a>
<a id="schema_ComprehensiveInventoryDailySnapshotVO"></a>
<a id="tocScomprehensiveinventorydailysnapshotvo"></a>
<a id="tocscomprehensiveinventorydailysnapshotvo"></a>

```json
{
  "statDate": "string",
  "sampleSize": 0,
  "avgCount": 0,
  "finalCount": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|statDate|string|false|none||统计日期。|
|sampleSize|integer|false|none||当日样本数量。|
|avgCount|number|false|none||当日平均数量。|
|finalCount|integer|false|none||当日最终建议数量。|

<h2 id="tocS_ComprehensiveInventoryPenReportVO">ComprehensiveInventoryPenReportVO</h2>

<a id="schemacomprehensiveinventorypenreportvo"></a>
<a id="schema_ComprehensiveInventoryPenReportVO"></a>
<a id="tocScomprehensiveinventorypenreportvo"></a>
<a id="tocscomprehensiveinventorypenreportvo"></a>

```json
{
  "penId": 0,
  "penName": "string",
  "includedDays": 0,
  "avgDailyCount": 0,
  "recommendedCount": 0,
  "deadPigQuantity": 0,
  "dailySnapshots": [
    {
      "statDate": "string",
      "sampleSize": 0,
      "avgCount": 0,
      "finalCount": 0
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|penId|integer(int64)|false|none||栏舍ID。|
|penName|string|false|none||栏舍名称。|
|includedDays|integer|false|none||纳入统计的天数。|
|avgDailyCount|number|false|none||日最终值平均数。|
|recommendedCount|integer|false|none||建议数量。|
|deadPigQuantity|integer|false|none||区间内死猪总数。|
|dailySnapshots|[[ComprehensiveInventoryDailySnapshotVO](#schemacomprehensiveinventorydailysnapshotvo)]|false|none||每日快照列表。|

<h2 id="tocS_ComprehensiveInventoryBuildingReportVO">ComprehensiveInventoryBuildingReportVO</h2>

<a id="schemacomprehensiveinventorybuildingreportvo"></a>
<a id="schema_ComprehensiveInventoryBuildingReportVO"></a>
<a id="tocScomprehensiveinventorybuildingreportvo"></a>
<a id="tocscomprehensiveinventorybuildingreportvo"></a>

```json
{
  "buildingId": 0,
  "buildingName": "string",
  "pens": [
    {
      "penId": 0,
      "penName": "string",
      "includedDays": 0,
      "avgDailyCount": 0,
      "recommendedCount": 0,
      "deadPigQuantity": 0,
      "dailySnapshots": [
        {
          "statDate": "string",
          "sampleSize": 0,
          "avgCount": 0,
          "finalCount": 0
        }
      ]
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|buildingId|integer(int64)|false|none||楼栋ID。|
|buildingName|string|false|none||楼栋名称。|
|pens|[[ComprehensiveInventoryPenReportVO](#schemacomprehensiveinventorypenreportvo)]|false|none||栏舍列表。|

<h2 id="tocS_ComprehensiveInventoryReportVO">ComprehensiveInventoryReportVO</h2>

<a id="schemacomprehensiveinventoryreportvo"></a>
<a id="schema_ComprehensiveInventoryReportVO"></a>
<a id="tocScomprehensiveinventoryreportvo"></a>
<a id="tocscomprehensiveinventoryreportvo"></a>

```json
{
  "orgId": 0,
  "orgName": "string",
  "startDate": "string",
  "endDate": "string",
  "buildings": [
    {
      "buildingId": 0,
      "buildingName": "string",
      "pens": [
        {
          "penId": 0,
          "penName": "string",
          "includedDays": 0,
          "avgDailyCount": 0,
          "recommendedCount": 0,
          "deadPigQuantity": 0,
          "dailySnapshots": [
            {}
          ]
        }
      ]
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|orgId|integer(int64)|false|none||组织ID。|
|orgName|string|false|none||组织名称。|
|startDate|string|false|none||开始日期。|
|endDate|string|false|none||结束日期。|
|buildings|[[ComprehensiveInventoryBuildingReportVO](#schemacomprehensiveinventorybuildingreportvo)]|false|none||楼栋列表。|

<h2 id="tocS_ResultComprehensiveInventoryReportVO">ResultComprehensiveInventoryReportVO</h2>

<a id="schemaresultcomprehensiveinventoryreportvo"></a>
<a id="schema_ResultComprehensiveInventoryReportVO"></a>
<a id="tocSresultcomprehensiveinventoryreportvo"></a>
<a id="tocsresultcomprehensiveinventoryreportvo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "orgId": 0,
    "orgName": "string",
    "startDate": "string",
    "endDate": "string",
    "buildings": [
      {
        "buildingId": 0,
        "buildingName": "string",
        "pens": [
          {
            "penId": null,
            "penName": null,
            "includedDays": null,
            "avgDailyCount": null,
            "recommendedCount": null,
            "deadPigQuantity": null,
            "dailySnapshots": null
          }
        ]
      }
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[ComprehensiveInventoryReportVO](#schemacomprehensiveinventoryreportvo)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_PdfExportVO">PdfExportVO</h2>

<a id="schemapdfexportvo"></a>
<a id="schema_PdfExportVO"></a>
<a id="tocSpdfexportvo"></a>
<a id="tocspdfexportvo"></a>

```json
{
  "objectKey": "string",
  "accessUrl": "string",
  "fileName": "string",
  "generatedAt": "string",
  "cached": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|objectKey|string|false|none||PDF 对象Key。|
|accessUrl|string|false|none||PDF 访问地址。|
|fileName|string|false|none||文件名。|
|generatedAt|string|false|none||生成时间。|
|cached|boolean|false|none||是否命中已缓存PDF。|

<h2 id="tocS_ResultPdfExportVO">ResultPdfExportVO</h2>

<a id="schemaresultpdfexportvo"></a>
<a id="schema_ResultPdfExportVO"></a>
<a id="tocSresultpdfexportvo"></a>
<a id="tocsresultpdfexportvo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "objectKey": "string",
    "accessUrl": "string",
    "fileName": "string",
    "generatedAt": "string",
    "cached": true
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[PdfExportVO](#schemapdfexportvo)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_DeadPigMediaVO">DeadPigMediaVO</h2>

<a id="schemadeadpigmediavo"></a>
<a id="schema_DeadPigMediaVO"></a>
<a id="tocSdeadpigmediavo"></a>
<a id="tocsdeadpigmediavo"></a>

```json
{
  "id": 0,
  "picturePath": "string",
  "similarityScore": 0
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|id|integer(int64)|false|none||图片ID。|
|picturePath|string|false|none||图片访问地址。|
|similarityScore|number|false|none||相似度分数。|

<h2 id="tocS_DeadPigReportVO">DeadPigReportVO</h2>

<a id="schemadeadpigreportvo"></a>
<a id="schema_DeadPigReportVO"></a>
<a id="tocSdeadpigreportvo"></a>
<a id="tocsdeadpigreportvo"></a>

```json
{
  "reportId": 0,
  "orgId": 0,
  "penId": 0,
  "reportDate": "string",
  "quantity": 0,
  "remark": "string",
  "status": "string",
  "createdAt": "string",
  "mediaList": [
    {
      "id": 0,
      "picturePath": "string",
      "similarityScore": 0
    }
  ]
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|reportId|integer(int64)|false|none||上报单ID。|
|orgId|integer(int64)|false|none||组织ID。|
|penId|integer(int64)|false|none||栏舍ID。|
|reportDate|string|false|none||上报日期。|
|quantity|integer|false|none||死猪数量。|
|remark|string|false|none||备注。|
|status|string|false|none||上报状态。|
|createdAt|string|false|none||创建时间。|
|mediaList|[[DeadPigMediaVO](#schemadeadpigmediavo)]|false|none||图片列表。|

<h2 id="tocS_MonoResultDeadPigReportVO">MonoResultDeadPigReportVO</h2>

<a id="schemamonoresultdeadpigreportvo"></a>
<a id="schema_MonoResultDeadPigReportVO"></a>
<a id="tocSmonoresultdeadpigreportvo"></a>
<a id="tocsmonoresultdeadpigreportvo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": {
    "reportId": 0,
    "orgId": 0,
    "penId": 0,
    "reportDate": "string",
    "quantity": 0,
    "remark": "string",
    "status": "string",
    "createdAt": "string",
    "mediaList": [
      {
        "id": 0,
        "picturePath": "string",
        "similarityScore": 0
      }
    ]
  },
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[DeadPigReportVO](#schemadeadpigreportvo)|false|none||数据|
|ok|boolean|false|none||none|

<h2 id="tocS_ResultListDeadPigReportVO">ResultListDeadPigReportVO</h2>

<a id="schemaresultlistdeadpigreportvo"></a>
<a id="schema_ResultListDeadPigReportVO"></a>
<a id="tocSresultlistdeadpigreportvo"></a>
<a id="tocsresultlistdeadpigreportvo"></a>

```json
{
  "code": 0,
  "message": "string",
  "data": [
    {
      "reportId": 0,
      "orgId": 0,
      "penId": 0,
      "reportDate": "string",
      "quantity": 0,
      "remark": "string",
      "status": "string",
      "createdAt": "string",
      "mediaList": [
        {
          "id": 0,
          "picturePath": "string",
          "similarityScore": 0
        }
      ]
    }
  ],
  "ok": true
}

```

### 属性

|名称|类型|必选|约束|中文名|说明|
|---|---|---|---|---|---|
|code|integer|false|none||编码：1成功，0和其它数字为失败|
|message|string|false|none||错误信息|
|data|[[DeadPigReportVO](#schemadeadpigreportvo)]|false|none||数据|
|ok|boolean|false|none||none|

