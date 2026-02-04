<h1 align="center">📰 Nortus App</h1>

## :memo: Descrição

Aplicativo Flutter com arquitetura limpa (Clean Architecture) que apresenta uma lista de notícias com paginação, favoritos (somente em memória), e uma navegação simples entre páginas. O projeto enfatiza o uso de Cubit/Bloc para gerenciamento de estado e boas práticas de componentização.

## 🎞️ Splash Screen nativa

Splash nativa configurada com o pacote [flutter_native_splash](https://pub.dev/packages/flutter_native_splash), garantindo experiência consistente no Android e iOS.

## 🧊 State: Bloc/Cubit

Gerenciamento de estado via `flutter_bloc`/`bloc`, com `NewsCubit` seguindo o state pattern para carregar páginas, atualizar favoritos e reagir a mudanças.

## 📰 Módulo de Notícias

- Paginação de 5 em 5 itens com scroll infinito.
- Pull-to-refresh e retry em caso de erro.
- Rodapé indicando fim da lista quando não há mais itens.
- Favoritar/desfavoritar com snackbar de feedback; favoritos mantidos apenas em memória.
- Filtro “Somente favoritos” via texto com underline usando a cor `AppColors.buttonColor`.

### Detalhe da Notícia

Layout alinhado ao modelo com:

- Botão de voltar com texto ao lado.
- Linha com chip de categoria e botão de favorito.
- Título e linha “Publicado em: dd/MM/yyyy”.
- Imagem destacada com bordas arredondadas.
- Texto maior com conteúdo/resumo.

Componentes reutilizáveis:

- `BackTextButton`, `CategoryChip`, `FavoriteIconButton`, `NewsHeroImage`.

## 🧭 Navegação

`GoRouter` com rotas para Splash, Auth, Home (News + Perfil) e Detalhe da notícia. TabBar na AppBar (inline ao lado do logo) em `HomePagerPage`.

## :wrench: Tecnologias

![Dart](https://img.shields.io/badge/Dart-0D1117?style=for-the-badge&logo=dart&logoColor=0175C2)
![Flutter](https://img.shields.io/badge/Flutter-0D1117?style=for-the-badge&logo=flutter&logoColor=0175C2)

Versão do Flutter: 3.32.7

## 📦 Pacotes principais

- dio
- flutter_bloc / bloc
- go_router
- get_it
- cached_network_image
- connectivity_plus
- flutter_native_splash
- mocktail / bloc_test (testes)

## ⚠️ Requisitos

Para rodar aplicações Flutter, certifique-se que sua máquina possui:

- Dart SDK
- Flutter SDK
- Um device físico (USB) ou um emulador (Android Studio)

## :rocket: Rodando o projeto

```bash
# Instale dependências
fvm flutter pub get

# Rode testes (opcional)
fvm flutter test -r expanded

# Execute o app
fvm flutter run
```

> Se não utiliza `fvm`, substitua por `flutter` nos comandos acima.

## :handshake: Colaboradores

<table>
	<tr>
		<td align="center">
			<a href="http://github.com/CaioReis29">
				<img src="https://github.com/CaioReis29.png" width="100px;" alt="Caio Reis"/><br>
				<sub><b>Caio Reis</b></sub>
			</a>
		</td>
	</tr>
	<tr>
		<td align="center">
			<sub><b>Equipe Nortus</b></sub>
		</td>
	</tr>
</table>
