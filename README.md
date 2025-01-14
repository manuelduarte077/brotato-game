# pay_reminder

## Features

- Creación de recordatorios:
  Agregar nuevos pagos con detalles como monto, fecha de vencimiento, descripción y categoría.
  Establecer recordatorios recurrentes (semanales, mensuales, anuales).

- Listas de pagos:
  Organizar los pagos en diferentes listas (por categoría, proveedor, etc.).
  Priorizar pagos importantes.

- Calendario de pagos:
  Visualizar todos los pagos programados en un calendario.
  Identificar rápidamente los pagos próximos.

- Compartir pagos:
  Compartir pagos con otras personas (por ejemplo, compañeros de piso).
  Poder agregar a una persona que ya este registrado su correo en firebase, entonces invitarlo a ese reminder y que el pueda verlo tambien

- Autenticación con Google:
  Información del perfil: Ver información básica del perfil del usuario (nombre, correo electrónico, foto de perfil).

- Profile Screen
  Opciones para cambiar el idioma, tema
  Saber si esta autenticado, para asi poder guardar de manera online
  Perfil del usuario, si tiene cuenta mostrar la foto de google
  Agregar Categorias
  Lista Notificaciones(Locales, Remotas(Push))
  Cerrar session si esta logueado

  
- Reportes con Gráficos:
  Mostrar graficos, cual son los pagos mas altos, tiempo de antiguedad

- Notificaciones:
  Recibir recordatorios a través de notificaciones.
  Personalizar la frecuencia de las notificaciones (5, 2 o 1días antes de la fecha de vencimiento).
  Lista de notificaciones, borrar notificaciones leidas (No leidas, recientes, Leidas)

- Personalización:
  Elegir entre diferentes temas
  Elegir diferentes idiomas


El recurrenceInterval generalmente se refiere al intervalo o frecuencia con la que se repite un recordatorio. Su significado específico depende del recurrenceType que se esté utilizando. Por ejemplo:

Si recurrenceType es "diario" y recurrenceInterval es 12:
  El recordatorio se repetirá cada 12 días
  
Si recurrenceType es "mensual" y recurrenceInterval es 12:
  El recordatorio se repetirá cada 12 meses (es decir, una vez al año)
Si recurrenceType es "semanal" y recurrenceInterval es 12:
  El recordatorio se repetirá cada 12 semanas
Es importante notar que recurrenceInterval NO significa el número de veces que se repetirá el recordatorio, sino cada cuánto tiempo se repetirá. Es decir:

  ❌ NO significa "repetir 12 veces"
  ✅ Significa "repetir cada 12 [unidades de tiempo]"
Por ejemplo, si configuras:

```dart
recurrenceType: "daily"
recurrenceInterval: 3
``