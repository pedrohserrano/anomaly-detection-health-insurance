Business Analytics Issues
======

#### Reuniones con Lederman

1. Entrega Viernes Abril 6
+ Notebook días promedio hospitalización
+ Notebook EDA
+ Markdown de las extracciones del DWH
+ Grafo de participantes

2. Entrega Lunes Abril 24
+ Dashboard de Tableau (variables categóricas y mapas)
+ Resolver el tema de las variables continuas con los montos y eso

3. Entrega Miércoles Mayo 10
+ Análisis de pólizas, similar al de siniestros
+ Grafo con resultados
+ Definiciones de anomalias por distintos tipos de casos
+ Notebook más completo resumido

Decir que estoy en espera de layout y de tratamiento de variables y feature engenirreng
Mostrar las nuevas variables creadas
Mostrar las suposiciones de anomalías
Un tableau
Una corrida predictiva de siniestros

Tiré un predicción de monto y nada, tire un número de reclamaciones y nada

4. Entrega Jueves Mayo 18 - Tratar de cambiar a 30
+ Presentación que va a dirección
+ Definiciones de casos anómalos
+ Ejemplos concretos de casos
+ Unos ejemplos de como se vería la predicción


#### Anomalies Detection on Health Insurance Claims

1. Exploratory Data Analysis
    + DWH Knowledge
    + Features knowledge
    + Descriptive

2. Training set integration
    + Full join data set
    + Feature ingeneering
    + Descriptive

3. Machine Learning
    + Model Selection
    + Model Optimization
    + Descriptive


#### Análisis descriptivo (Machote de Storytelling)

Introducción del Problema de detección de anomalías
Antecedentes de situaciones en el negocio

Introducción a las variables utilizadas y las más relevantes
Cifras globales históricas
Cifras globales por variables

Definicíón de anomalías
Definición de que valores y bajo que combinaciones son presumiblemente anómalos



#### Tipos de fraude definidos por Banorte

1. Fraudes del asegurado
    + Declaraciones y/o documentos falsos
    + Comportamiento del reclamante: Agresivo, presiona por una solución rápida, sin voluntad de cooperar, preferencia marcada por doctores, etc.
    + Característica del siniestro: Sucede poco después del inicio de la cobertura o justo antes de que cese la vigencia, no corresponde con las declaraciones, etc.
    + Características del reclamante: Su situación financiera es mala, tiene un historial de reclamos recientes, frecunetes cambios de aseguradora, ect.

2. Fraudes del intermediario
    + Aumemto excepcional de la producción sin motivo aparente.
    + Cambios frecuentes de dirección, o que no corresponde con la zona donde opera.
    + Su cartera tiene una gran cantidad de seguros con características especiales.
    + Frecuentes endosos, cancelaciones, y renovaciones de pólizas, etc.
    + Antecedentes de malas practicas, emisiones en falso, etc.

3. Fraudes del proveedor
    + Reportado con antecedentes negativos (por AMIS o por otras aseguradoras).
    + Elevada incidencia de mismos ajustadores, valuadores o dictaminadores
    + Cobro de servicios que exceden a los inicialmente estimados
    + Frecuentes ajustes a los montos de los servicios
    + Volumen comparativamente elevado de casos y con clientes geográficamente distantes.

4. Fraudes con participación de Personal Interno
    + Nivel de vida inexplicable o por arriba de las posibilidades de ingreso.
    + Relaciones estrechas y convivencias frecuentes con proveedores
    + Gerentes con elevado control y/o autoridad, sin supervisión o auditorías periódicas
    + Gerentes o empleados con relaciones preferenciales o de larga duración con externos.
    + Gerentes o empleados que trabajan hasta tarde, se niegan a tomar vacaciones, que actúan de manera evasiva y que parecen tensión permanente.



#### Áreas de oportunidad/Preguntas

- Necesito los datos de las cosas que si fueron fraude ¿Existe algo así?  
	+ No existe, se busca descubrir anomalías
	+ Será un modelado no supervisado
- Classification in fraud and no fraud claims  
	+ La clasificación la podemos hacer después cuando ya tengamos los fraudes-tipo
- The type of custumers whose gonna get the policy  
	+ Hay que preguntarse quien es el contratante modelo de GMM, y dirigir la venta a ese tipo de persona
- Necesito ver los prospectos clasificados para GMM  
- Conocimiento de catálogo de enfermedades  
- Hay que saber cuales son las reglas actuales de negocio para suscripción de GMM  
- Objetivos de negocio:  
	+ Se quiere minimizar los costos  
	+ Queremos tener más clientes  
	+ Queremos retener los que ya tenemos 
- Los dictaminadores no tienen tiempo de revisar bien cada reclamación y pueden haber errores, revisar reglas de ajuste  
- Hay que hacer escenearios que comparen el monto de las reclamaciones con y sin anomalias para comparar la diferencia y el ahorro por usar analytics  
- Hacer un análisis de grafos con agentes, suscriptores, doctores, personas, etc, para después hacer clusters  
- Tenemos datos de proveedores fraudulentos?  
- Tenemos algo así como notas de los doctores? De que van los informes médicos
- Hay información de que planes de GMM anteriores tienen?  
- Tenemos datos de satsfacción de los clientes?  
- Hay que ver la base de reclamaciones que se rechazan
- Definir la probabilidad de reclamación, Existe?



- Total claim? revisar tema de reserva
- Categorizar reclamaciones por padecimiento
- Descriptivo de pólizas, comparar con S.A.
- Costos medios de padecimientos (gente de negocio que negocía con provedores)
- Revisar descripciones que no necesariamente correpondan a GMM
- Proyección de reservas dado en training (prducto prestadores de servicios)
- Distancia de la reclamación al inicio o fin de vigencia de la póliza
- Días promedio de hospitalización, relación con productos, póliza de la judicatura, que distribución tiene


#### Análisis Exploratorio de Datos

1. Diccionario de definición de variables  
- Numéricas, continuas, categóricas etc

2. Para las variables continuas:  

- ¿Qué podemos encontrar?
    - Asimetría
    - *Outliers*
    - Multimodalidad
    - Huecos (*Gaps*)
    - *Heaping*
    - Redondeos
    - Imposibilidades
    - Errores

- ¿Cómo visualizarlas?
    - *Histogramas* Muestran la distribución empírica (*raw*)
        - ¡*Empírica*!  No son estimadores...
    - *Boxplot* Despliega *outliers*. Estadística Robusta (tener cuidado con el paquete que se utilice). Comparación entre subgrupos.
    - *Dotplot* Cada observación un punto, permnite detectar *huecos* en los datos
    - *Rugplot* Cada observación como una pequeña línea en el eje horizontal, se usa en conjunto con otras gráficas
    - *Density estimate* Es como un *modelo* de los datos
         - Sólo recuerda los límites de las variables, sobre si todo si son estrictos: *siempre* revisa la documentación.
    - *Distribution estimate* Útil para comparar distribuciones (e.g. ver si una está adelante de la otra)
    - *QQ plot* Compara la distribución contra una distribución teórica (por *default* es la distribución normal)


3. Reescalamiento de Variables continuas:  
+ Desviación estándar
+ Rango intercuantil
+ PCP plots para comparar las variables una vez que estén normalizadas

- Normalizar
    - Es útil cuando las cantidades absolutas son menos importantes que las relativas.
    
- Normalizar y reescalar 
    - Usar la desviación estándar como unidad de medida.
    - Tiene mucho sentido si la distribución es simétrica.
    - Si no lo es, es posible que sea *lognormally distributed* 
     (como el ingreso monetario o los gastos), una transformación `log10()`
     lo hará útil.
- Es una buena idea usar `log` si el rango de tus datos cubre varios ordenes de magnitud. 
    - Regularmente, estas variables vienen de procesos **multiplicativos** en lugar de aditivos. 

- Si el rango incluye cantidades negativas, usa (crea) una función `signedLog10`

4. Análisis de Correlaciones: 

+ Scatterplots
+ Matrices de correlaciones


5. Para las variables categóricas

+ Tabla comparativa
+ Clásico pie
+ En cuanto a los tipos de gráficos tenemos *mosaicplots*, *doubledecker plots*, *fluctuation diagrams*, *treemaps*, *association plots* 
y *parallel sets / categorical parallel coordinate plots*.

ojo: - Para variable categórica y numérica es recomendable usar `boxplot` (en su versión de `violin` o `jitter`).


6. Hacer los datos Tidy

Dificultades de hacerlo tidy  
- Nombres de las columnas representan valores de los datos en lugar de nombres de variables
- Una columna contiene varias variables en lugar de una variable
- Una tabla contiene más de una unidad de observación
- Las variables están contenidas en los renglones y columnas, en lugar de sólo columnas.
- Los datos de una unidad observacional están dispersas en varios *data sets*

7. Missing values 

Aguas con los missing values, que son en cada caso, a veces son casos no documentados

- ¿Valores faltantes?    
- ¿Valores inválidos?
- ¿Outliers?
- ¿Rangos?
    - Es importante saber cuanto varía la variable.
    - Si es muy amplio, puede ser un problema para algunos algoritmos de modelado.
    - Si varía muy poco (o nada) no puede ser usado como predictor.
- ¿Unidades?

Ya sea imputar o excluir aplica para outluiers tanto como para missing values

Revisar correlaciones de missing values con otras variables y descubrir si "desaparecen" juntas

    x <- as.data.frame(abs(is.na(df))) # df es un data.frame
    # Extrae las variables que tienen algunas celdas con NAs
    y <- x[which(sapply(x, sd) > 0)] 
    # Da la correación un valor alto positivo significa que desaparecen juntas.
    cor(y) 

Para las categóricas el NA puede ser una categoría o nivel más

- Una estrategia es rellenar los valores faltantes con alguna medida de centralidad.
    - Media, mediana, moda, etc.
- Para variables distribuidas normalmente, esta opción es la mejor.
- Pero para variables *skewed*  o con *outliers* esta decisión puede ser desastrosa.
    + en general (`median` si es numérica, `moda` si es categórica)

Para una imputación más pro
+ Ver la correlación de las variables
    * Si es alta entonces la dependiente se puede imputar con una regresión gracias a la independiente

8. Construcción de Módulos para hacer pipeline

`00-load.R`, `01-prepare.R` y `02-clean.R` y `run.R`


#### Segmentación de siniestros

No queremos resolver la pregunta ¿Quienes son los más propensos a tener un siniestro? ya que se supone que es lo que hace el área técnica
Lo que se resuelve será:

¿Cuales son las reclamaciones o segmentos más propensos a tener anomalías en un siniestro?

Las anomalías no son necesariamente actos ilegales, si no de abuso también, en cualquier caso es la salida de dinero que no debió de pasar


----

+ Anomalías

Intentos de reclamaciones de medicamentos, consultas, etc, que no tengan que ver con el siniestro
    (Una solución es la de poner la bandera, de tipo de rechazo en la reclamación)
    Así ya tenemos una bandera con la que entrenar

Días de más en el hospital

Un siniestro que no haya sido siniestro, o accidente inventado
    Para que un siniestro simulado ocurra se necesita complicidad del asegurado y del doctor
    Entonces el doctor tiene que dictar un diagnóstico, falsificar estudios, y probablemente engañar al hospital
    Para este tipo, los dispaeadores del siniestro pueden ser:
        que el asegurado no haya pedido segundas opiniones
        que los trámites sean rápidos
        que la reclamación se pida por reembolso




-----

Con ayuda de el entendimiento de las variables categóricas y continuas se puede hacer segmentación del dataset, es decir, crear subdatasets para entrenar por separado.

Cada ramificación debe distribuir la población cercanamente a la mitad, lo mismo con el monto
Las variables presumibles para hacer segmentación vía árboles binarios son:

Número de siniestros para una póliza, mayor o menor a un corte
Número de reclamaciones en un siniestro, mayor o menor a un corte
Si se trata de accidente o enfermedad, embarazo
Si se trata de NL o fuera
SI es un hombre o mujer
Todas las variables relacionadas con Días transcurridos
Tipo de agente (definir 2 tipos homogeneos)
Tipo de prestador de servicios (definir 2 tipos homogeneos)




#### Tipos de variables a considerar  

#### Estadísticos:  
De la población y de lo siniestrado  

- Número de Evento
- Monto de Siniestros
- Monto promedio por siniestro

#### Agregaciones  

Demográficos:  

- Enfermedad
- Género 

		DWHHOM.HUB_TIPO_PARTICIPANTE
		DWHHOM.SAT_PERSONA
- Edad
- Ubicación

		DWHHOM.SAT_DIRECCION
		DWHHOM.SAT_SEPOMEX
- Hay relaciones de roles

		DWHHOM.HUB_RELACION_ROL
		DWHHOM.HUB_ROL
		DWHHOM.LINK_PARTICIPANTE_TIPO
- Momento en el tiempo

Póliza:  

- Estatus de la póliza

        SELECT ('0'+pol.STPOLIZA) STATUS, cve.INTMEDIA, COUNT(*) policies
        FROM DWHRAW.S_SABE_POLIZA pol 
        LEFT JOIN (SELECT ('0'+VALOR) STAT, INTMEDIA FROM DWHRAW.S_SABE_CLAVES WHERE DATO='STPOLIZA'GROUP BY VALOR, INTMEDIA, ('0'+VALOR)) cve 
        ON cve.STAT=('0'+pol.STPOLIZA) --We use the 0 trick to make the variables equal
        GROUP BY pol.STPOLIZA, cve.INTMEDIA, ('0'+pol.STPOLIZA)
        ORDER BY STATUS;
- Tipo de producto/ramo/subramo

        SELECT pol.RAMSUBRAMO, COUNT(*) Policies, cat.NOMBREL Product
        FROM DWHRAW.S_SABE_POLIZA pol 
        LEFT JOIN DWHRAW.C_SABE_CATRAMOS cat
        ON pol.RAMSUBRAMO=cat.RAMSUBRAMO_ID
        GROUP BY pol.RAMSUBRAMO, cat.NOMBREL
        ORDER BY policies DESC;
- Cuanto paga de prima

        DWHRAW.S_SABE_POLIZA
- Tipo de póliza (individual, familiar, grupo)

		DWHHOM.LINK_POLIZA_ESTATUS
		DWHHOM.SAT_DETALLE_POLIZA
		DWHHOM.SAT_ESTATUS_POLIZA (CAT)
- Tipo de participante

		DWHHOM.SAT_ORGANIZACION
		DWHHOM.SAT_ORGANIZACION_COMPLEMENTA
- Tipo de cobertura/póliza

		C_SABE_NORMACOB
- Distancia al tiempo de gracia/tiempo de espera
- Agente, Status

        SELECT TIPO_AGE, COUNT(*) agents FROM DWHRAW.S_CUA_TAGENTESADN
        GROUP BY TIPO_AGE ORDER BY agents DESC;
    + Suscriptor/Región de suscripción/tipo suscripción
- Nodos y relaciones

		SAT_PARENTESCO
		SAT_ROL
- Cancelaciones?

		C_SABE_CAUSACAN
- Tipo de pago

		C_SABE_ESQFPAGO

####Relacionados a los Siniestros

+ Grupo de padecimientos
+ Doctor/Prestador de servicio
+ Hospitales/Proveedores
+ Dictaminador/Ajustador
+ Ocupación del siniestrado
+ Relación riesgo / suma asegurada
+ Días de hospitalización 
+ Tiempo total del proceso de siniestro



#### Dudas de DWH

- El registro vigente para cualquier tiene que tener WHERE ESTATUS_IND=1
- Sufijo RT, no les hago caso
- sini_siniestr es solo GMM? si no, como distinguimos GMM y AP? con RANSUBRAMO
- Que es C_SABE_CATALUEN no hacerle caso tampoco
- Participantes consultar en: S_SABE_ASEGURPL
- Para S_SABE_POLIZA cual es el campo del tiempo
    + FSTAT fecha de cambio del último estatus de la póliza
    + FINIVIG inicio de vigencia
    + FTERVIG termino/fin de vigencia
- Se comparó en count de pólizas y el count de pólizas en la tabla de siniestros, hay 3.93% hace sentido con el negocio? 59,694 / 1,516,323
- Hay estadísticas del negocio como cuantos siniestros promedio por póliza, cuantas reclamaciones promedio por asegurado, etc.      
    + Consultar con Estadística de GMM
- Como puedo ligar los datos del agente con sus demográficos y con los participantes que se involucra
    + S_CUA_TAGENTESADN (Caracterristicas de las personas )
    + Pedro M me ayudará a investicar la variable y/o catalogo TIPO_AGE  de S_CUA_TAGENTESADN
    + S_CUA_TOFICINAADN (Características de las promotoria de la que depende el agente, )
    + Estructura jerárquica de promotoria, TJERARQUIALPADN
    + s_cua_toficinaadn (ES LA RELACIÓN DE LA OFICINA CON EL AGENTE)
    + S_CUA_TOFICINA (detalle y jerarquía de las oficinas)
- Existe algo así como tipo de siniestro y tipo de reclamación
    + Diccionario de datos de siniestros
- Hay tablas relacionadas con litigio
    + Diccionario de datos de siniestros
- La suma de los pagos de los siniestros
    + Diccionario de datos de siniestros
- Luce que es un poco más sencilla de entender la homologada, se puede desagregar los datos de las personas?
    + Script de relación de persona-póliza
- Tablas de hospitales y proveedores
    + S_SABE_PRESTSER
    + S_SABE_INSTITUC
- Tablas de dictaminadores
    + ST_SINI_RECLAM     (IDCAPT) Usuario interno
- Grupos de padecimientos y accidentes
    + Diccionario de datos de siniestros
- Que es ESTIMADO
    + Es el presupuesto de cada reclamación, puede llevarse a cabo o no
- Que es SAT_CUENTA en HOM?
	+ Es el monto que se asigna a las reclamaciones
- Catálogo Estatus Póliza
	+ Es en realidad un catálogo de claves
	+ `SELECT * FROM DWHRAW.S_SABE_CLAVES WHERE DATO='STPOLIZA' ORDER BY DATO DESC`
- Que es un participante de HUB_PARTICIPANTE DE HOM
	+ Es una entidad de necogio física o moral
	+ Es cualquier entidad que gira en torno a una póliza  
- HUB_POLIZA son todas las pólizas del negocio?
	+ En efecto, son todas las del negocio
	+ Se pueden agregar con SOURCE_CD para identificar su fuente, aún así no tiene por que cuadrar ya que las actualizaciones del DWH so mensuales
- Que es el sufijo CD 
	+ Quiere decir que el campo es un código, y así todos los sufijos, únicamente indican el tipo de dato al que se refiere el campo
- Sufijos 
	+ H=HUB tabla con llaves principales
	+ C=Catálogo
	+ SAT=Satélite tablas con información detalle de HUB
- Para identificar si una póliza ha recibido cambios o no a nivel base de datos: ESTATUS_IND
- Para conocer los Montos pagados
	+ Es en campo IMPPAGMN de la tabla PAGOS todo relacionado por el NSINIEST de cada una de las tablas involucradas
 



#### Indemnizaciones

Revisar cifras de referencia para cuadrar con análisis

+ Número de pólizas siniestradas mensuales histórico
+ Número de siniestros mensuales histórico
+ Número de reclamaciones mensuales histórico
+ Número de médicos en red
+ Número de agentes
+ Número pro


#### Proceso GMM  
--SINIESTRO->CNS->SAS(SISTEMA DE ADMINISTRACIÓN DE SINIESTROS)->SE GUARDA EN SABE->RECLAMOS Y DICTAMINACIONES->PAGOS Y REEMBOLSOS

####Oportunidades de Analítica 

Healthcare organizations can analyze patient records and billing to detect anomalies such as:
- A hospital’s overutilization of services in short time periods  
- Patients receiving healthcare services from different hospitals in different locations simultaneously  
- Identical prescriptions for the same patient filled in multiple locations.

First of all we need to be clear every variable could helps to understand the global distributions of 3 important agregations Policy, Insured and Sinister in order to set the rules and parameters to measuring the claims

A claim is the smallest part 

Retención de Clientes - 

Fraud – One out of 10 insurance claims is fraudulent. How do you spot those before a hefty payout is made? Most fraud solutions on the market today are rules-based. Unfortunately, it is too easy for fraudsters to manipulate and get around the rules. Predictive analysis, on the other hand, uses a combination of rules, modeling, text mining, database searches and exception reporting to identify fraud sooner and more effectively at each stage of the claims cycle.  

Subrogation – Opportunities for subro often get lost in the sheer volume of data – most of it in the form of police records, adjuster notes and medical records. Text analytics searches through this unstructured data to find phrases that typically indicate a subro case. By pinpointing subro opportunities earlier, you can maximize loss recovery while reducing loss expenses.  

Settlement – To lower costs and ensure fairness, insurers often implement fast-track processes that settle claims instantly. But settling a claim on-the-fly can be costly if you overpay. Any insurer who has seen a rash of home payments in an area hit by natural disaster knows how that works. By analyzing claims and claim histories, you can optimize the limits for instant payouts. Analytics can also shorten claims cycle times for higher customer satisfaction and reduced labor costs. It also ensures significant savings on things such as rental cars for auto repair claims.
Loss reserve – When a claim is first reported, it is nearly impossible to predict its size and duration. But accurate loss reserving and claims forecasting is essential, especially in long-tail claims like liability and workers’ compensation. Analytics can more accurately calculate loss reserve by comparing a loss with similar claims. Then, whenever the claims data is updated, analytics can reassess the loss reserve, so you understand exactly how much money you need on hand to meet future claims.  

Activity – It makes sense to put your more experienced adjusters on the most complex claims. But claims are usually assigned based on limited data – resulting in high reassignment rates that effect claim duration, settlement amounts and ultimately, the customer experience. Data mining techniques cluster and group loss characteristics to score, prioritize and assign claims to the most appropriate adjuster based on experience and loss type. In some cases, claims can even be automatically adjudicated and settled.  

Litigation – A significant portion of a company’s loss adjustment expense ratio goes to defending disputed claims. Insurers can use analytics to calculate a litigation propensity score to determine which claims are more likely to result in litigation. You can then assign those claims to more senior adjusters who are more likely to be able to settle the claims sooner and for lower amounts.

Descriptivo
=======

Hoja 1

(el modelo de entrenamiento tomaría de 2005 a 2015) y otro de todo

(el modelo de entrenamiento trataría al extranjero y a Monterrey por aparte para no meter ruido)

Hoja 2

(Se propondrá un modelo para AP y otro para GMM)

Hoja 3

Análisis por tipo de siniestro, el tipo de siniestro al final no dice mucho, entonces los tres niveles Ramo, Subramo, Tipo de Siniestro, se resume en accidentes y enfermedades, entonces lo que veo es que hay que hacer un dataset para accidentes y otro para enfermedades, y meterme a ver los catálogos de enferemdades ni modo y asesorarme con las áreas corresponeidntes, también conlleva a un reetiquetado con fines para el análisis.

(En el dataset de entrenamiento excluiría el desempleo, suicidio por que no hay datos suficientes para entrenar e incluiría las consideraciones de las anomalías contextuales)

Hoja 4

(Incluiría data sets de entrenamiento categorizando las edaddes y el número de reclamaciones)}

Hoja 5

(Hay que hacer una lista de casos, y decidir el tipo de anomalía)

De hecho en la relación de grados, no se observan los primeos como hospitales de Monterrey
son el Dalinde, Country en Jalisco, Medica Sur


Variables para el dataset de entrenamiento
=========

nodes-relations
"NSINIEST","DATE_SIN","POLICY_NAME","INSURED_NAME","AGENT_ID","OFFICE_ID","OFFICE_NAME","PHISYCIAN","HOSP_ID","HOSP_NAME","DICTAMIN"

polizas-ubicacion
"RAMSUBRAMO_POL","NPOLIZA_POL","COLONIA_POL","POBLACION_POL","ENTIDAD_FEDERATIVA_POL","CODIGO_POSTAL_POL","LATITUD_POL","LONGITUD_POL","PRIMA_ANUAL_POL","NUMERO_ASEGURADOS_POL"

siniestros-desc
"NSINIEST","NPOLIZA","RAMSUBRAMO","RAMO","SUBRAMO","DATE_INIT","INI_ANIO","INDIVIDUAL","EDO","STATE_NAME","CITY","CITY_NAME","NASEG","NOMBTIT","GENDER","CVNFUMA","RIESGOCUP","CVEDOCIV","AGE","SINISTER_DATE","TIPOSIN","SIN_DECRIPTION","DIS_DESCRIPTION","COVERS","TOTAL_CLAIM","TOTAL_PAID","DIFF_MOUNT","CLAIMS"

sinister-type
"NSINIEST","RAMSUBRAMO","EDO","CIUDAD","NOMBREPOB","CLAIMS"


- Asegurado sea cualquier persona que goce de alguna cobertura dentro de la póliza de GMM


EN la tabla de poliza -persona-sabe hacer los counts, también polizas-ubicacion tiene counts de ubicación
Hacer un modelo de cluster en nodes-relation y también de siniestros

Problemas que han habido n la descripción de los siniestros



Tabla de padecimientos

TUMOR
TRAUM
TROMBO
TRANST
PARTO
TOXO
TOR (TORSION)
TIRO (TIROIDE)
TESTI (TESTICULAR)
TERATOMA
TENOS (TENOSINOVITIS)
TEND (TENDONES)
TCE, T.C.E
TAQUI
TALLA (TALLA BAJA)
TABIQUE
SX
SINDROME
SD
SUFR (SUFRE)
SUBOCLUSION
SUBLUXACION
SINUS (SINUSITIS)
SINOVITIS
SINEQUIA
SINCOPE
SIALOADENITIS
SEPSIS
SEMIMOMA
SARCOMA
SANGRADO
SALMON
RUPTURA
SECUELA
RIN (SINOSINOSITIS)
RETRA (RETASO)
REFLUJO
RECIEN (NEONATO)



Segmentación de Cartera para TMK
========

Ana María Gaspar  

Necesito saber como funciona el negocio
Cual es la operación de inicio a fin de un seguro
Cual es la operación de inicio a fin de una campaña
Necesito saber cual es el objetivo de cada negocio


1 Issue diferentes fuentes
Hay retro de call center
Entregables son tablas
Las validaciones las hacen a mano
Mejores campañas? campañas inteligentes? solución tecnológica?
Efectividad de campañas


