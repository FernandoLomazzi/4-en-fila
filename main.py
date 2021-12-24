from pyswip import Prolog
from tkinter import *
from tkinter import messagebox
import random
import time
#+==========Prolog============+#
#Entra una query y la formatea
def formatear(query):
    tableroRet = []
    for i in query:
        tableroAUX = []
        for x in i:
            tableroAUX.append(str(x))
        tableroRet.append(tableroAUX)
    return tableroRet
#Realizar una query en prolog. q nombre query, atributos lista con atributos
def pquery(q,atributos):
    q += '('
    for i in range(len(atributos)):
        q += str(atributos[i])+"," if i<len(atributos)-1 else str(atributos[i])
    q += ")"
    return list(prolog.query(q))
prolog = Prolog()
prolog.consult("prolog.pl")
#+==========Interfaz==========+#
root = Tk()
root.title("4 en fila")
root.resizable(False,False)
root.iconbitmap("./imagenes/icono.ico")
fondo = "#2c3e50"
fondoBoton = "#1c2833"
tableroColor = "#a3218e"
ficha1Color = "#fdf300"
ficha2Color = "#07a761"
fuente = "Fixedsys 20"
turno = None
inicio = None
pantallaJuego = None
tableroJ = None
finalizado = None 
jugador1 = None
jugador2 = None
maquina = None
dificultad = None
def pantallaInicio():
    global inicio,coopIMG,maqIMG
    setVar()
    inicio = Frame(root,bg=fondo)
    inicio.pack(fill="both",expand=True)
    textoInicio = Label(inicio,text="4 en FILA",pady=15,fg='white',font=fuente,bg=fondo,padx=25)
    textoInicio.pack(side="top")
    coopIMG = PhotoImage(file='./imagenes/JcJ.png')
    comenzarCoop = Button(inicio,bg=fondo,activebackground=fondoBoton,image=coopIMG,padx=5,pady=5,command = lambda: partidaCoop())
    comenzarCoop.pack(pady=(45,10),padx=20)
    maqIMG = PhotoImage(file='./imagenes/JcM.png')
    comenzarMaquina = Button(inicio,image=maqIMG,activebackground=fondoBoton,bg=fondo,padx=5,pady=5,command=lambda: seleccionarDif())
    comenzarMaquina.pack()
    salirJuego = Button(inicio, text="Salir",font=fuente,padx=5,pady=5,command = lambda: root.destroy())
    salirJuego.pack(pady=10)
def victoria():
    global finalizado,jugador1,jugador2
    query = pquery('conecta4',[tableroJ,'P','L'])
    if not query:
        return
    messagebox.showinfo("Ganador","Jugador {}".format(turno+1))
    if turno:
        jugador2 += 1
    else:
        jugador1 += 1
    finalizado = True
def empate():
    global finalizado
    query = pquery('empate',[tableroJ])
    if not query:
        return
    messagebox.showinfo("Empate",":(")
    finalizado = True
def jugadaDificil(ficha):
    query = pquery('jugadaDefinitiva',[tableroJ,ficha,'C']) 
    if query:
        return query
    query = pquery('jugadaSeguraPro',[tableroJ,ficha,'C'])
    if query:
        return query
    query = pquery('jugadaSegura',[tableroJ,ficha,'C'])
    if query:
        return query
    return pquery('columnaDisp',[tableroJ,'C'])
def jugadaMaquina(tablero,fichas):
    time.sleep(0.05)
    ficha = 'a' if turno==0 else 'b'
    if dificultad=='normal':
        jugada = pquery('jugadaIA',[tableroJ,ficha,'C',dificultad])
    else:
        jugada = jugadaDificil(ficha)
    jugadaFinal = jugada[random.randint(0,len(jugada)-1)]['C']-1
    ingresarFicha(jugadaFinal,tablero,fichas,None,0)
def ingresarFicha(n,tablero,fichas,jugadorTexto,aux):
    global tableroJ,turno
    colorFicha = ficha1Color if turno==0 else ficha2Color
    fila = int(pquery('filaDisp',[tableroJ,n+1,'F'])[0]['F'])-1
    if fila<0:
        return
    tableroJ = formatear(pquery('ingresarFicha',[tableroJ,n+1,'a' if turno==0 else 'b','T2'])[0]['T2'])
    tablero.itemconfigure(fichas[fila][n],fill=colorFicha)
    victoria()
    empate()
    turno = 1-turno
    if finalizado:
        if maquina:
            partidaMaquina()
        else:
            partidaCoop()
        return
    if maquina:
        if aux:
            jugadaMaquina(tablero,fichas)
    else:
        jugadorTexto.configure(text="Jugador {}".format(turno+1))
def setVar():
    global inicio,pantallaJuego,turno,tableroJ,finalizado,jugador1,jugador2,maquina
    if inicio!=None and inicio.winfo_exists():
        inicio.destroy()
        jugador1 = 0
        jugador2 = 0
    if pantallaJuego!=None and pantallaJuego.winfo_exists():
        pantallaJuego.destroy()    
    turno = 0
    tableroJ = formatear(pquery('tableroInicial',['X'])[0]['X'])
    finalizado = False
    maquina = False
def cambiarDif(s):
    global dificultad
    dificultad = s
    partidaMaquina()
def seleccionarDif():
    dif = Toplevel(inicio,bg=fondo)
    dif.iconbitmap("./imagenes/icono.ico")
    difTexto = Label(dif,text="Selecciona la dificultad",fg='white',bg=fondo,padx=15,font=fuente)
    medioDif = Button(dif,text="normal",font=fuente,command=lambda: cambiarDif("normal"))
    difDif = Button(dif,text="dificil",font=fuente,command=lambda: cambiarDif("dificil"))
    difTexto.grid(row=0,column=0,columnspan=4)
    medioDif.grid(row=1,column=0,columnspan=2,pady=15)
    difDif.grid(row=1,column=2,columnspan=2)
def partidaMaquina():
    global maquina
    setVar()
    maquina = True
    setTablero()
def partidaCoop():
    setVar()
    setTablero()
def setTablero():
    global pantallaJuego,turno,maquina
    pantallaJuego = Frame(root,bg=fondo)
    regresar = Button(pantallaJuego,text="regresar",activebackground=fondoBoton,command=pantallaInicio,font=fuente,fg='white',bg=fondo)
    jugadorTexto = Label(pantallaJuego, text="Jugador 1" if maquina==False else dificultad,font=fuente,fg="white",bg=fondo)
    contadorTexto = Label(pantallaJuego, text="{}-{}".format(jugador1,jugador2),font=fuente,bg=fondo,fg="white")
    tablero = Canvas(pantallaJuego,width=570,height=490,bg=tableroColor,highlightthickness=0)
    fichas = [[0 for x in range(7)] for y in range(6)] 
    for i in range(6):
        p1 = [80*i+10,10]
        p2 = [80+80*i,80]
        for j in range(7):
            fichas[i][j] = tablero.create_oval(p1[1],p1[0],p2[1],p2[0],fill=fondo,outline="")
            p1[1] += 80
            p2[1] += 80
    botonCol = [0 for x in range(7)]
    for i in range(7):
        botonCol[i] = Button(pantallaJuego,padx=15,command = lambda x=i: ingresarFicha(x,tablero,fichas,jugadorTexto,True))
        botonCol[i].grid(row=8,column=i)
    pantallaJuego.pack()
    regresar.grid(row=0,column=0,columnspan=2)
    jugadorTexto.grid(row=0,column=2,columnspan=3)
    contadorTexto.grid(row=0,column=6,columnspan=2)
    tablero.grid(row=1,column=0,columnspan=7,rowspan=6,padx=10)
pantallaInicio()
root.mainloop()
