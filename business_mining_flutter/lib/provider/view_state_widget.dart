import 'package:business_mining/common/icon_font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'view_state.dart';

/// 加载中
class ViewStateBusyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
      ),
    );
  }
}

/// 基础Widget
class ViewStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final Widget image;
  final Widget buttonText;
  final String buttonTextData;
  final VoidCallback onPressed;
  final TextStyle titleStyle;

  ViewStateWidget(
      {Key key,
      this.image,
      this.title,
      this.message,
      this.buttonText,
      @required this.onPressed,
      this.buttonTextData,
      this.titleStyle})
      : super(key: key);

  var _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var _titleStyle = Theme.of(context).textTheme.subhead.copyWith(color: Colors.grey, fontSize: 13);
    var messageStyle = _titleStyle.copyWith(color: _titleStyle.color.withOpacity(0.7), fontSize: 12);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        image ?? Icon(IconFonts.pageError, size: 80, color: Colors.grey[500]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                title ?? "异常信息",
                style: titleStyle ?? _titleStyle,
              ),
              SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200, minHeight: 16),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Text(message ?? '', style: messageStyle),
                ),
              ),
            ],
          ),
        ),
        Offstage(
          offstage: onPressed == null,
          child: Center(
            child: ViewStateButton(
              child: buttonText,
              textData: buttonTextData,
              onPressed: onPressed,
            ),
          ),
        ),
      ],
    );
  }
}

/// ErrorWidget
class ViewStateErrorWidget extends StatelessWidget {
  final ViewStateError error;
  final String title;
  final String message;
  final Widget image;
  final Widget buttonText;
  final String buttonTextData;
  final VoidCallback onPressed;

  const ViewStateErrorWidget({
    Key key,
    @required this.error,
    this.image,
    this.title,
    this.message,
    this.buttonText,
    this.buttonTextData,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultImage;
    var defaultTitle;
    var errorMessage = error.message;
    String defaultTextData = "重试";
    switch (error.errorType) {
      case ViewStateErrorType.networkTimeOutError:
        defaultImage = Transform.translate(
          offset: Offset(-50, 0),
          child: const Icon(IconFonts.pageNetworkError, size: 100, color: Colors.grey),
        );
        defaultTitle = "网络异常";
        // errorMessage = ''; // 网络异常移除message提示
        break;
      case ViewStateErrorType.defaultError:
        defaultImage = const Icon(IconFonts.pageError, size: 100, color: Colors.grey);
        defaultTitle = "异常";
        break;

      case ViewStateErrorType.unauthorizedError:
        return ViewStateUnAuthWidget(
          image: image,
          message: message,
          buttonText: buttonText,
          onPressed: onPressed,
        );
    }

    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image ?? defaultImage,
      title: title ?? defaultTitle,
      message: message ?? errorMessage,
      buttonTextData: buttonTextData ?? defaultTextData,
      buttonText: buttonText,
    );
  }
}

/// 页面无数据
class ViewStateEmptyWidget extends StatelessWidget {
  final String message;
  final Widget image;
  final Widget buttonText;
  final VoidCallback onPressed;
  final TextStyle style;

  const ViewStateEmptyWidget({Key key, this.image, this.message, this.buttonText, this.onPressed, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image ?? const Icon(IconFonts.pageEmpty, size: 100, color: Colors.grey),
      title: message ?? "无数据",
      buttonText: buttonText,
      buttonTextData: "点击刷新",
      titleStyle: style,
    );
  }
}

/// 页面未授权
class ViewStateUnAuthWidget extends StatelessWidget {
  final String message;
  final Widget image;
  final Widget buttonText;
  final VoidCallback onPressed;

  const ViewStateUnAuthWidget({Key key, this.image, this.message, this.buttonText, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image ?? ViewStateUnAuthImage(),
      title: message ?? "用户未登录",
      buttonText: buttonText,
      buttonTextData: "用户未登录",
    );
  }
}

/// 未授权图片
class ViewStateUnAuthImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'loginLogo',
      child: Image.asset(
        'img/logo.png',
        width: 130,
        height: 100,
        fit: BoxFit.fitWidth,
        color: Theme.of(context).accentColor,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}

/// 公用Button
class ViewStateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final String textData;

  const ViewStateButton({@required this.onPressed, this.child, this.textData})
      : assert(child == null || textData == null);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: child ??
          Text(
            textData ?? "重试",
            style: TextStyle(wordSpacing: 5),
          ),
      textColor: Colors.grey,
      splashColor: Theme.of(context).splashColor,
      onPressed: onPressed,
      highlightedBorderColor: Theme.of(context).splashColor,
    );
  }
}
