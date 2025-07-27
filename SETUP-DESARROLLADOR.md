# 🚀 Guía de Configuración para Nuevos Desarrolladores

## Bienvenido al Proyecto TVA Experience

Esta guía te ayudará a configurar tu entorno de desarrollo local paso a paso.

## 📋 Prerrequisitos

### 1. Herramientas Básicas
```bash
# Verificar que tienes instalado:
node --version    # v16.x o superior
npm --version     # v8.x o superior
git --version     # v2.x o superior
```

### 2. AWS CLI
```bash
# Instalar AWS CLI
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# Verificar instalación
aws --version
```

### 3. SAM CLI
```bash
# Instalar SAM CLI
brew install aws-sam-cli

# Verificar instalación
sam --version
```

### 4. Docker
```bash
# Instalar Docker Desktop desde: https://www.docker.com/products/docker-desktop
# O con Homebrew:
brew install --cask docker

# Verificar instalación
docker --version
```

## 🔧 Configuración del Proyecto

### 1. Clonar el Repositorio
```bash
git clone <URL_DEL_REPOSITORIO>
cd login/sam-tva-experience
```

### 2. Configurar AWS (Opcional para desarrollo local)
```bash
# Configurar credenciales AWS (solo si vas a desplegar)
aws configure
# AWS Access Key ID: [Tu Access Key]
# AWS Secret Access Key: [Tu Secret Key]
# Default region name: us-east-1
# Default output format: json
```

### 3. Instalar Dependencias del Proyecto
```bash
# Ejecutar script de configuración
./setup.sh

# O manualmente:
sam build
```

## 🧪 Configuración de Testing

### 1. Instalar Newman (CLI de Postman)
```bash
# Instalar Newman globalmente
npm install -g newman

# Verificar instalación
newman --version
```

### 2. Instalar Herramientas de Documentación (Opcional)
```bash
# Para visualizar documentación OpenAPI
npm install -g swagger-ui-serve

# Para generar clientes de API
npm install -g @openapitools/openapi-generator-cli
```

## 🚀 Primeros Pasos

### 1. Iniciar el Servidor Local
```bash
# Construir y iniciar API local
sam build && sam local start-api --port 3000

# En otra terminal, verificar que funciona:
curl http://localhost:3000/login
```

### 2. Ejecutar Tests
```bash
# Validación rápida
cd postman && ./quick-test.sh

# Tests completos
newman run postman/TVA-Experience-API-Complete.postman_collection.json \
  -e postman/Local-Environment.postman_environment.json
```

### 3. Ver Documentación
```bash
# Servir documentación interactiva
swagger-ui-serve openapi.yaml
# Abrir: http://localhost:3000
```

## 📁 Estructura del Proyecto

```
sam-tva-experience/
├── functions/              # Código de las funciones Lambda
│   ├── login/             # Función de login principal
│   ├── loginEmail/        # Login por email
│   └── ...                # Otras 14 funciones
├── events/                # Eventos de prueba
├── postman/               # Scripts de testing
│   ├── *.postman_collection.json
│   ├── *.postman_environment.json
│   └── quick-test.sh      # Script de validación rápida
├── template.yaml          # Plantilla SAM
├── openapi.yaml          # Documentación de la API
├── setup.sh              # Script de configuración
└── README.md             # Documentación principal
```

## 🔐 Variables de Entorno

### Para Testing Local
Crea tu propio archivo de entorno basado en el ejemplo:

```bash
# Copiar archivo de ejemplo
cp postman/Local-Environment.postman_environment.json \
   postman/My-Local-Environment.postman_environment.json

# Editar con tus valores
# - user_email: tu email de prueba
# - user_password: tu contraseña de prueba
```

### Para AWS (Opcional)
```bash
# Solo si vas a desplegar a AWS
cp postman/Dev-Environment.postman_environment.json \
   postman/My-Dev-Environment.postman_environment.json
```

## 🧪 Flujo de Desarrollo

### 1. Desarrollo Local
```bash
# Terminal 1: Iniciar SAM
sam local start-api --port 3000

# Terminal 2: Hacer cambios en el código
# Los cambios se reflejan automáticamente

# Terminal 3: Ejecutar tests
cd postman && ./quick-test.sh
```

### 2. Testing Completo
```bash
# Ejecutar todos los tests
newman run postman/TVA-Experience-API-Complete.postman_collection.json \
  -e postman/My-Local-Environment.postman_environment.json \
  --reporters cli,html \
  --reporter-html-export test-results.html
```

### 3. Documentación
```bash
# Ver documentación interactiva
swagger-ui-serve openapi.yaml

# Buscar TODOs pendientes
grep -n "TODO:" openapi.yaml
```

## 🐛 Solución de Problemas Comunes

### Error: "Docker no está ejecutándose"
```bash
# Iniciar Docker Desktop
open -a Docker  # En macOS

# Verificar que Docker esté ejecutándose
docker ps
```

### Error: "SAM CLI no encontrado"
```bash
# Reinstalar SAM CLI
brew uninstall aws-sam-cli
brew install aws-sam-cli
```

### Error: "Newman no encontrado"
```bash
# Instalar Newman
npm install -g newman

# Verificar instalación
newman --version
```

### Error: "Puerto 3000 en uso"
```bash
# Usar puerto diferente
sam local start-api --port 3001

# Actualizar base_url en archivo de entorno de Postman
```

### Error: "Timeout en tests"
```bash
# Aumentar timeout en Newman
newman run collection.json -e environment.json --timeout-request 10000
```

## 📚 Recursos Adicionales

### Documentación
- [AWS SAM Developer Guide](https://docs.aws.amazon.com/serverless-application-model/)
- [Postman Learning Center](https://learning.postman.com/)
- [OpenAPI Specification](https://swagger.io/specification/)

### Herramientas Útiles
- [Postman Desktop](https://www.postman.com/downloads/) - Para GUI de testing
- [VS Code](https://code.visualstudio.com/) - Editor recomendado
- [AWS Toolkit for VS Code](https://aws.amazon.com/visualstudiocode/) - Extensión AWS

### Extensiones VS Code Recomendadas
```bash
# Instalar extensiones útiles
code --install-extension ms-vscode.vscode-json
code --install-extension 42Crunch.vscode-openapi
code --install-extension ms-python.python
code --install-extension ms-vscode.vscode-typescript-next
```

## 🤝 Contribuir

### Antes de hacer cambios:
1. Ejecutar tests: `cd postman && ./quick-test.sh`
2. Verificar documentación: `swagger-ui-serve openapi.yaml`
3. Revisar .gitignore para no commitear archivos temporales

### Flujo de trabajo:
1. Crear rama: `git checkout -b feature/mi-feature`
2. Hacer cambios
3. Ejecutar tests completos
4. Commitear: `git commit -m "feat: descripción del cambio"`
5. Push: `git push origin feature/mi-feature`
6. Crear Pull Request

## 📞 Soporte

Si tienes problemas:
1. Revisar esta guía
2. Consultar README.md del proyecto
3. Revisar logs de SAM: `sam logs`
4. Consultar con el equipo

---

**¡Bienvenido al equipo! 🎉**

Una vez que tengas todo configurado, podrás:
- ✅ Desarrollar localmente con SAM
- ✅ Ejecutar tests automatizados
- ✅ Ver documentación interactiva
- ✅ Contribuir al proyecto con confianza
