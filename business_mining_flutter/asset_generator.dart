// Copyright 2018 DebuggerX <dx8917312@gmail.com>. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

///修改源码，手动指定asset源地址

const preview_server_port = 2227;

//const pic_path = "asset/img/";
const svg_path = "asset/svg/";
const img_path = "asset/img/";

void main(List<String> args) async {
  var resource = <String>[];
  generateResString(resource, img_path);
  resource.add("\n");
  generateResString(resource, svg_path);

  var r = new File('lib/r.dart');
  if (r.existsSync()) {
    r.deleteSync();
  }
  r.createSync();
  var content =
      "///\n///自动生成的资源类，现包括普通图片、svg图片，请勿手动修改，生成脚本为根目录下asset_generator.dart\n///可用 Ctrl+Shift+N 快速定位到文件\n///\n";
  content = '${content}class R {\n  R._();\n';
  for (var line in resource) {
    content = '$content  $line\n';
  }
  content = '$content}\n';
  r.writeAsStringSync(content);

  print(args);
  if (args == null || args.isEmpty) {
    await startServer();
  }
}

Future startServer() async {
  var ser;
  try {
    ser = await HttpServer.bind('127.0.0.1', preview_server_port);
    print('成功启动图片预览服务器于本机<$preview_server_port>端口');
    ser.listener(
      (req) {
        var index = req.uri.path.lastIndexOf('.');
        var subType = req.uri.path.substring(index);
        req.response
          ..headers.contentType = new ContentType('image', subType)
          ..add(new File('.${req.uri.path}').readAsBytesSync())
          ..close();
      },
    );
  } catch (e) {
    print('图片预览服务器已启动或端口被占用');
  }
}

void generateResString(List<String> resource, String path) {
  var directory = new Directory(path);
  if (directory.existsSync()) {
    var list = directory.listSync(recursive: true);
    for (var file in list) {
      if (new File(file.path).statSync().type == FileSystemEntityType.file) {
        var path = file.path.replaceAll('\\', '/');
        if (path.contains("/.")) {
          //隐藏文件跳过
          continue;
        }
        var temp = path.replaceAll("asset/", "").replaceAll('/', '_');
        var varName = temp.substring(0, temp.lastIndexOf(".")).replaceAll('.', '_').toLowerCase();
        var pos = 0;
        String char;
        while (true) {
          pos = varName.indexOf('_', pos);
          if (pos == -1) break;
          char = varName.substring(pos + 1, pos + 2);
          varName = varName.replaceFirst('_$char', '_${char.toUpperCase()}');
          pos++;
        }
        varName = varName.replaceAll('_', '');
        resource.add("/// ![](http://127.0.0.1:$preview_server_port/$path)");
        resource.add("static const String $varName = '$path';");
      }
    }
  } else {
    throw new FileSystemException('Directory wrong');
  }
}
