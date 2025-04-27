export function setearTabla(transacciones){
  let tabla = `
    <div class="relative overflow-hidden shadow-md rounded-lg mt-4">
      <table class="table-fixed w-full text-left border-collapse">
        <thead class="uppercase bg-[#265fbb] text-[#f3f7ff]">
          <tr>
            <th class="py-3 px-4 border border-gray-200 text-center font-bold">Fecha</th>
            <th class="py-3 px-4 border border-gray-200 text-center font-bold">Tipo de Movimiento</th>
            <th class="py-3 px-4 border border-gray-200 text-center font-bold">Monto</th>
            <th class="py-3 px-4 border border-gray-200 text-center font-bold">Nuevo Saldo</th>
            <th class="py-3 px-4 border border-gray-200 text-center font-bold">Usuario</th>
            <th class="py-3 px-4 border border-gray-200 text-center font-bold">IP</th>
            <th class="py-3 px-4 border border-gray-200 text-center font-bold">Estampa de tiempo</th>
          </tr>
        </thead>
        <tbody class="bg-white text-[#6b7280]">
  `;

  for (const trans of transacciones) {
    tabla += `
      <tr class="hover:bg-gray-100">
        <td class="py-3 px-4 border border-gray-200 text-center">${new Date(trans.Fecha).toLocaleDateString()}</td>
        <td class="py-3 px-4 border border-gray-200 text-center">${trans.Nombre}</td>
        <td class="py-3 px-4 border border-gray-200 text-center">${trans.Monto}</td>
        <td class="py-3 px-4 border border-gray-200 text-center">${trans.NuevoSaldo}</td>
        <td class="py-3 px-4 border border-gray-200 text-center">${trans.Username}</td>
        <td class="py-3 px-4 border border-gray-200 text-center">${trans.PostInIp}</td>
        <td class="py-3 px-4 border border-gray-200 text-center">${new Date(trans.PostTime).toLocaleString()}</td>
      </tr>
    `;
  }

  tabla += `
        </tbody>
      </table>
    </div>
  `;

  return tabla

}