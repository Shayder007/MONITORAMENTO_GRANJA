# App Granja 🐔

[![Flutter](https://img.shields.io/badge/Flutter-3.10.4-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.4-0175C2.svg)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Realtime%20DB-orange.svg)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#licença)

Aplicação mobile de monitoramento e controle de galpões em tempo real com foco em redução de quebras de motores e otimização operacional.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Screenshots](#screenshots)
- [Features](#features)
- [Requisitos](#requisitos)
- [Instalação](#instalação)
- [Stack Técnico](#stack-técnico)
- [Arquitetura](#arquitetura)
- [Licença](#licença)

---

## 🎯 Visão Geral

**App Granja** é uma solução mobile desenvolvida para a **Granja Pensamento** que permite monitoramento em tempo real de linhas de produção e motores. A aplicação fornece insights valiosos sobre desempenho operacional, histórico de manutenções e alertas automáticos para reduzir perdas e otimizar custos.

### Objetivo Principal
Realizar monitoramento por galpão e reduzir quebras nas linhas de produção de motores para:
- ✅ Reduzir gastos operacionais
- ✅ Minimizar perdas por paradas não planejadas
- ✅ Aumentar eficiência produtiva
- ✅ Facilitar manutenção preventiva

---

## 📱 Screenshots

### Visão Geral das Telas

| Tela Inicial | Menu Principal | Galpões |
|:---:|:---:|:---:|
| ![Sobre Nós](./screenshots/01_sobre_nos.png) | ![Menu](./screenshots/02_menu.png) | ![Galpões](./screenshots/03_galpoes.png) |
| Tela inicial com informações sobre a aplicação | Drawer com opções de navegação | Lista de galpões cadastrados |

| Detalhes do Galpão | Dashboard do Galpão | Detalhes da Linha |
|:---:|:---:|:---:|
| ![Galpão A](./screenshots/04_galpao_a.png) | ![Dashboard Galpão](./screenshots/05_dashboard_galpao.png) | ![Linha Primária](./screenshots/06_dashboard_linha_primaria.png) |
| Visualização de linhas do galpão | Dashboard com dados em tempo real | Gráfico histórico de medições |

| Alertas | Manutenções | Registrar Manutenção |
|:---:|:---:|:---:|
| ![Alertas](./screenshots/07_alertas.png) | ![Manutenções](./screenshots/08_manutencoes.png) | ![Registrar](./screenshots/09_registrar_manutencao.png) |
| Sistema de notificações e alertas | Histórico de manutenções realizadas | Formulário para registrar manutenção |

---

## ⭐ Features

### 📊 Dashboard e Monitoramento
- ✅ Visualização em tempo real de RPM dos motores
- ✅ Gráficos de histórico com dados das últimas medições
- ✅ Status de conexão com dispositivos (Online/Offline)
- ✅ Indicadores de linhas em funcionamento e ativas

### 🏢 Gerenciamento de Galpões
- ✅ Múltiplos galpões com linhas independentes
- ✅ Visualização hierárquica (Galpão → Linhas → Dados)
- ✅ Status consolidado por galpão
- ✅ Edição de informações de galpões

### 🚨 Sistema de Alertas
- ✅ Notificações em tempo real para anomalias
- ✅ Histórico de alertas
- ✅ Classificação por severidade

### 🔧 Registro de Manutenções
- ✅ Formulário intuitivo para registrar manutenções
- ✅ Tipos de manutenção predefinidos
- ✅ Seleção de técnico responsável
- ✅ Data e hora automáticas
- ✅ Campo de observações

### 📈 Análises e Relatórios
- ✅ Total de medições por linha
- ✅ Histórico de leituras com timestamps
- ✅ Última atualização em tempo real

### 🌓 Experiência do Usuário
- ✅ Tema claro/escuro adaptativo
- ✅ Interface intuitiva e responsiva
- ✅ Navegação por abas e drawer
- ✅ Material Design 3

---

## 📦 Requisitos

- **Flutter** 3.10.4 ou superior
- **Dart** 3.10.4 ou superior
- **Android SDK** 21+ ou **iOS** 11.0+
- **Git** para clonar o repositório
- **Conta Firebase** com projeto configurado

### Verificar Instalação

```bash
flutter --version
dart --version
flutter doctor
```

---

## 🚀 Instalação

### 1. Clonar o Repositório

```bash
git clone https://github.com/seu-usuario/app_granja.git
cd app_granja
```

### 2. Instalar Dependências

```bash
flutter pub get
```

### 3. Configurar Firebase

```bash
flutterfire configure
```

### 4. Executar o Projeto

```bash
flutter run
```

---

## 🛠️ Stack Técnico

### Frontend
- **Framework**: Flutter 3.10.4
- **Linguagem**: Dart 3.10.4
- **State Management**: Riverpod 2.5.1
- **Design**: Material Design 3

### Backend & Dados
- **Backend**: Firebase Realtime Database
- **Gráficos**: FL Chart 0.70.0
- **Localização**: Intl 0.19.0

### Plataformas
- ✅ Android (SDK 21+)
- ✅ iOS (11.0+)
- ⚙️ Web, Windows, macOS, Linux (em desenvolvimento)

---

## 🏗️ Arquitetura

O projeto segue a arquitetura **Clean Architecture**:

```
lib/
├── core/                 # Núcleo compartilhado
│   ├── config/
│   ├── theme/
│   └── utils/
│
├── data/                 # Camada de dados
│   ├── models/
│   ├── repositories/
│   └── services/
│
├── features/             # Features (módulos)
│   ├── about/
│   ├── alerts/
│   ├── barns/
│   ├── dashboard/
│   ├── maintenance/
│   └── motors/
│
├── presentation/         # Camada de apresentação
│   ├── providers/
│   ├── screens/
│   └── widgets/
│
└── main.dart            # Ponto de entrada
```

---

## 📁 Estrutura do Projeto

```
app_granja/
├── lib/
├── android/
├── ios/
├── test/
├── pubspec.yaml
├── analysis_options.yaml
├── firebase.json
└── README.md
```

---

## 🔧 Configuração Firebase

### Passo 1: Criar Projeto Firebase
1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Crie um novo projeto: `app_granja`

### Passo 2: Configurar Realtime Database
1. Clique em "Realtime Database"
2. "Criar banco de dados"
3. Localização: `south-america-east1`
4. Modo: "Iniciar em modo bloqueado"

### Passo 3: Adicionar Aplicativos
- **Android**: Package Name: `com.example.app_granja`
- **iOS**: Bundle ID: `com.example.appGranja`

---

## 📝 Padrão de Commits

Use Conventional Commits:

```bash
git commit -m "feat: adiciona novo dashboard"
git commit -m "fix: corrige bug em alertas"
git commit -m "docs: atualiza README"
```

---

## 🧪 Testes

```bash
# Executar todos os testes
flutter test

# Com cobertura
flutter test --coverage

# Teste específico
flutter test test/widget_test.dart
```

---

## 📱 Build

### Android
```bash
# APK Release
flutter build apk --release
```

### iOS
```bash
# iOS Release
flutter build ios --release
```

---

## 🐛 Troubleshooting

### Erro de Firebase no iOS
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

### Erro de Gradle no Android
```bash
flutter clean
flutter pub get
flutter run
```

---


## 🙏 Agradecimentos

- Flutter Team
- Firebase
- Comunidade Flutter
- Granja Pensamento

---

**Versão**: 1.0.0 | **Última atualização**: Maio 30, 2026
