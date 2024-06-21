// Datos desde la base de datos
const datosDesdeBD = [
    {
        'id': '1',
        'cliente': 'María',
        'concepto': 'Agua (2)',
        'precio': '$20',
        'total': '$20',
        'accion': 'Liquidar'
    },
    {
        'id': '2',
        'cliente': 'Juan',
        'concepto': 'Toalla',
        'precio': '$30',
        'total': '$30',
        'accion': 'Eliminar'
    },
    {
        'id': '3',
        'cliente': 'Carlos',
        'concepto': 'Sandalias',
        'precio': '$40',
        'total': '$40',
        'accion': 'Liquidar'
    },
    {
        'id': '1',
        'cliente': 'María',
        'concepto': 'Camiseta',
        'precio': '$15',
        'total': '$15',
        'accion': 'Eliminar'
    },
    {
        'id': '3',
        'cliente': 'Carlos',
        'concepto': 'Toalla',
        'precio': '$30',
        'total': '$30',
        'accion': 'Liquidar'
    },
    {
        'id': '3',
        'cliente': 'Pedro',
        'concepto': 'Toalla',
        'precio': '$30',
        'total': '$30',
        'accion': 'Liquidar'
    },
    {
        'id': '3',
        'cliente': 'luis',
        'concepto': 'Toalla',
        'precio': '$30',
        'total': '$30',
        'accion': 'Liquidar'
    },
    {
        'id': '3',
        'cliente': 'luis',
        'concepto': 'Toalla',
        'precio': '$30',
        'total': '$30',
        'accion': 'Liquidar'
    },
    {
        'id': '3',
        'cliente': 'luis',
        'concepto': 'Toalla',
        'precio': '$30',
        'total': '$30',
        'accion': 'Liquidar'
    },    
];

// Función para agrupar los productos por cliente
function agruparPorCliente(datos) {
    const clientes = {};

    datos.forEach((fila) => {
        const cliente = fila.cliente;
        if (!clientes[cliente]) {
            clientes[cliente] = [];
        }
        clientes[cliente].push(fila);
    });

    return clientes;
}

/* // Crear la tabla HTML
function crearTabla(datos) {
    const tabla = document.createElement('table');
    let total = 0;
    let total_general = 0;
    tabla.innerHTML = `
        <thead>
            <tr>
                <th>Cliente</th>
                <th>Concepto</th>
                <th>Precio</th>
                <th>Subtotal</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            ${Object.entries(datos).map(([cliente, productos]) => `
                ${total = 0}
                <tr>
                    <td rowspan="${productos.length}">${cliente}</td>
                    <td>${productos[0].concepto}</td>
                    <td>${productos[0].precio}</td>
                    <td>${productos[0].total}</td>
                    <td>${productos[0].accion}</td>
                    <td><a href='#' onclick='miFuncion(${productos[0].id})'>Liquidar</a></td>
                    ${total = total + parseFloat(productos[0].total.replace('$', ''))}
                    ${total_general = total_general + parseFloat(productos[0].total.replace('$', ''))}
                </tr>
                ${productos.slice(1).map((producto) => `
                    <tr>
                        <td>${producto.concepto}</td>
                        <td>${producto.precio}</td>
                        <td>${producto.total}</td>
                        <td>${producto.accion}</td>
                        <td><a href=v'#' onclick='miFuncion(${producto.id})'>Liquidar</a></td>
                        ${total = total + parseFloat(producto.total.replace('$', ''))}
                        ${total_general = total_general + parseFloat(producto.total.replace('$', ''))}

                    </tr>
                `).join('')}
                <tr>
                        <td colspan="3"></td> 
                        <td>Total: $${total.toFixed(2)}</td> 
                        <td></td> 
                </tr>
            `).join('')}
        </tbody>
    `;
    tabla.innerHTML += `
        <tfoot>
            <tr>
                <td colspan="3"></td>
                <td>Total general: $${total_general.toFixed(2)}</td>
                <td></td>
            </tr>
        </tfoot>
    `;

    return tabla;
}
function miFuncion(id){
    alert(id);
}

// Agregar la tabla al documento
const clientesAgrupados = agruparPorCliente(datosDesdeBD);
const tablaGenerada = crearTabla(clientesAgrupados);
//document.body.appendChild(tablaGenerada);


var tbody = document.getElementById("cuerpo");
tbody.appendChild(tablaGenerada); */

// Crear la tabla HTML
function crearTabla(datos) {
    const tabla = document.createElement('table');
    let total_general = 0; // Total general fuera del bucle

    tabla.innerHTML = `
        <thead>
            <tr>
                <th>Cliente</th>
                <th>Concepto</th>
                <th>Precio</th>
                <th>Subtotal</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            ${Object.entries(datos).map(([cliente, productos]) => {
                let total = 0; // Total por cliente
                let totalCliente = productos.reduce((acc, producto) => acc + parseFloat(producto.total.replace('$', '')), 0);
                total_general += totalCliente;

                return `
                    <tr>
                        <td rowspan="${productos.length}">${cliente}</td>
                        <td>${productos[0].concepto}</td>
                        <td>${productos[0].precio}</td>
                        <td>${productos[0].total}</td>
                        <td><a href='#' onclick='miFuncion(${productos[0].id})'>Liquidar</a></td>
                    </tr>
                    ${productos.slice(1).map((producto) => `
                        <tr>
                            <td>${producto.concepto}</td>
                            <td>${producto.precio}</td>
                            <td>${producto.total}</td>
                            <td><a href='#' onclick='miFuncion(${producto.id})'>Liquidar</a></td>
                        </tr>
                    `).join('')}
                    <tr>
                        <td colspan="3"></td>
                        <td>Total: $${totalCliente.toFixed(2)}</td>
                        <td></td>
                    </tr>
                `;
            }).join('')}
        </tbody>
    `;
    tabla.innerHTML += `
        <tfoot>
            <tr>
                <td colspan="3"></td>
                <td>Total general: $${total_general.toFixed(2)}</td>
                <td></td>
            </tr>
        </tfoot>
    `;

    return tabla;
}
function miFuncion(id){
    alert(id);
}

// Agregar la tabla al documento
const clientesAgrupados = agruparPorCliente(datosDesdeBD);
const tablaGenerada = crearTabla(clientesAgrupados);

var tbody = document.getElementById("cuerpo");
tbody.appendChild(tablaGenerada);






/* 
// Datos desde la base de datos
const datosDesdeBD = [
    {
        'id': '1',
        'cliente': 'María',
        'concepto': 'Agua (2)',
        'precio': '$20',
        'total': '$20',
        'accion': 'Liquidar',
        'tipo': 'producto'

    },
    {
        'id': '2',
        'cliente': 'Juan',
        'concepto': 'Toalla',
        'precio': '$30',
        'total': '$30',
        'accion': 'Eliminar',
        'tipo': 'producto'
    },
    {
        'id': '3',
        'cliente': 'Carlos',
        'concepto': 'Sandalias',
        'precio': '$40',
        'total': '$40',
        'accion': 'Liquidar',
        'tipo': 'producto'
    },
    {
        'id': '1',
        'cliente': 'María',
        'concepto': 'Camiseta',
        'precio': '$15',
        'total': '$15',
        'accion': 'Eliminar',
        'tipo': 'producto'
    },
    {
        'id': '3',
        'cliente': 'Carlos',
        'concepto': 'Toalla',
        'precio': '$30',
        'total': '$30',
        'accion': 'Liquidar',
        'tipo': 'producto'
    },
    {
        'id': '3',
        'cliente': 'Pedro',
        'concepto': 'Toalla',
        'precio': '$30',
        'total': '$30',
        'accion': 'Liquidar',
        'tipo': 'producto'
    },
    {
        'id': '3',
        'cliente': 'luis',
        'concepto': 'Toalla',
        'precio': '$30',
        'total': '$30',
        'accion': 'Liquidar',
        'tipo': 'producto'
    },
    {
        'id': '3',
        'cliente': 'luis',
        'concepto': 'Toalla',
        'precio': '$30',
        'total': '$30',
        'accion': 'Liquidar',
        'tipo': 'producto'
    },
    {
        'id': '3',
        'cliente': 'luis',
        'concepto': 'Toalla',
        'precio': '$30',
        'total': '$30',
        'accion': 'Liquidar',
        'tipo': 'producto'
    },    
];
 */