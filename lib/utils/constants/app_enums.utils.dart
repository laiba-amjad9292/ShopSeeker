enum PageType { home, search, add, activity, profile }

// Req Type
enum ReqType { get, post, put, patch, delete }

enum FeedType { writing, audio, video, photo }

// chat Type
enum MsgType { left, right }

enum CameraType { front, rear, any }

enum MediaType { video, image, audio }

enum VideoStates { idle, recording }

// Id Type

enum ParamType { simple, json }

enum BannerType { homePage, service }

// Show DataOr Loading
enum ShowData { showData, showNoDataFound, showLoading, showError }

enum CropperScreenType { full, previewOnly, crop }

// Toad Alert Types
// ignore: camel_case_types
enum TOAST_TYPE { toastInfo, toastSuccess, toastError }

enum SheetIconType { asset, svg, network, icon }

enum ToastType { success, error, warning, none }

enum StorageFolders { listings, profile }

enum AppMediaType {
  video,
  image,
  audio;

  String get value {
    switch (this) {
      case AppMediaType.video:
        return "video";
      case AppMediaType.image:
        return "image";
      case AppMediaType.audio:
        return "audio";
    }
  }

  String get typeName {
    switch (this) {
      case AppMediaType.video:
        return "video";
      case AppMediaType.image:
        return "image";
      case AppMediaType.audio:
        return "audio";
    }
  }
}
