# Репозиторий с пакетированием программы Loginom Community Edition дл дистрибютивов Arch Linux и пакетного менеджера Nix через Flake

## Предупреждение о Nix и NixOS
На NixOS приложение не работает по непонятным мне причинам (вероятно, чего-то нет в изолированной среде), максимум, чего мне удалось добиться, так это белого окна, говорящего о том, что CEF получает ошибку из-за чего-то (не понятно из-за чего, ибо нормально продебажить нельзя).
Пакетный менеджер Nix на других дистрибутивах работает с этим приложением нормально.

## Установка для Arch Linux (MAKEPKG)
```sh
git clone https://github.com/Urtyom-Alyanov/loginom-community-package.git
cd loginom-community-package
makepkg -si
```

Если будет не лень, то опубликую в AUR с автоматическим обновлением ссылки или добавлю уже собраный пакет для арча

## Установка Nix Flake (Экспериментально и не работает)

Просто добавьте это в свой `flake.nix`
```nix
{
  inputs = {
    # ... Другие инпуты

    loginom = {
      url = "github:Urtyom-Alyanov/loginom-community-package";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @inputs: { # <- inputs берется отсюда
    # ... То, что должно находится в аутпутах
    # Сам пакет доступен как inputs.loginom.packages.${final.system}.loginom-community, откуда берется inputs указано выше
  };
}
```

## Лицензия
Сама программа распространяется под проприетарной лицензий, сборщик распространяется под лицензией WTFPL
