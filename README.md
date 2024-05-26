# Dauillama

<img src="assets/app_icons/dauillamma.jpg" width="720">

a DArt(Flutter) UI for local [Ollama](https://ollama.com) API

- uses [Ollama Dart](https://pub.dev/packages/ollama_dart)

## Usage

Launch Ollama desktop app or run [ollama serve](https://github.com/ollama/ollama#start-ollama).

The [OllamaClient](https://pub.dev/documentation/ollama_dart/latest/ollama_dart/OllamaClient-class.html) attempts to retrieve the `OLLAMA_BASE_URL` from the environment variables, defaulting to http://127.0.0.1:11434/api if it is not set.

## Platforms
- [x] Macos
- [x] Windows
- [x] Linux
- [ ] Web

## Features

- [x] generate a chat completion
- [x] list models
- [x] show model information
- [x] pull a model
- [x] update a model  
- [x] delete a model
- [x] Chat history
- [ ] temperature & model options 
- [ ] create a model (modelFile)
- [ ] prompt templates library
- [ ] ollama settings customization

## Screenshots

<img src="assets/screenshots/conversation.png" width="720">

___

<img src="assets/screenshots/models.png" width="720">

___

<img src="assets/screenshots/model_info.png" width="720">

___

<img src="assets/screenshots/multi_modal.png" width="720">

___

<img src="assets/screenshots/pull_model.png" width="720">

---

<img src="assets/screenshots/light.png" width="720">
