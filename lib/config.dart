class DevHome {
  final urls = {
    'pubPhoto': 'http://192.168.0.105:8000/post-photo',
    'getPhoto': 'http://192.168.0.105:8000/get-photos',
    // 'userLocationGetter': 'ws://192.168.0.105:8000',
    'profilePhoto': 'http://192.168.0.105:8000/profile/update-photo',
    'profile': 'http://192.168.0.105:8000/profile',
    'user': 'http://192.168.0.105:8000/user',
    'media': 'http://192.168.0.105/',
  };
}

class DevWork {
  final urls = {
    'pubPhoto': 'http://192.168.2.232:8005',
    'getPhoto': 'http://192.168.2.232:8006',
    'userLocationGetter': 'ws://192.168.0.105:8002',
    'profilePhoto': 'http://192.168.2.232:8003/photo',
    'profile': 'http://192.168.2.232:8003',
    'user': 'http://192.168.2.232:8004',
  };
}

class Prod {
  final urls = {
    'pubPhoto': 'http://192.168.2.232:8005',
    'getPhoto': 'http://192.168.2.232:8006',
    'userLocationGetter': 'ws://192.168.0.105:8002',
    'profilePhoto': 'http://192.168.2.232:8003/photo',
    'profile': 'http://192.168.2.232:8003',
    'user': 'http://192.168.2.232:8004',
  };
}

var config = DevHome();
