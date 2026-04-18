let canvas = document.getElementById("canvas");
let ctx = canvas.getContext("2d");

// ===== SPLASH =====
window.addEventListener("load", () => {
  const splash = document.getElementById("splash");

  setTimeout(() => {
    splash.style.opacity = "0";
    splash.style.visibility = "hidden";
  }, 1500);
});

// ===== ESTADO =====
const estadoApp = {
  batalhao: null,
  tipoPolicia: "pm"
};

// ===== BATALHÕES =====
const batalhoes = [
  { nome: "1º BAEP", imagem: "assets/1baep.png" },
  { nome: "1º BPM/M", imagem: "assets/1bpmm.png" },
  { nome: "2º BAEP", imagem: "assets/2baep.png" },
  { nome: "6º BPM/I", imagem: "assets/6bpmi.png" },
  { nome: "8º BPM/I", imagem: "assets/8bpmi.png" },
  { nome: "16º BPM/I", imagem: "assets/16bpmi.png" },
  { nome: "18º BPM/I", imagem: "assets/18bpmi.png" },
  { nome: "27º BPM/M", imagem: "assets/27bpmm.png" },
  { nome: "31º BPM/I", imagem: "assets/31bpmi.png" },
  { nome: "34º BPM/I", imagem: "assets/34bpmi.png" },
  { nome: "35º BPM/I", imagem: "assets/35bpmi.png" },
  { nome: "37º BPM/M", imagem: "assets/37bpmm.png" },
  { nome: "38º BPM/M", imagem: "assets/38bpmm.png" },
  { nome: "47º BPM/I", imagem: "assets/47bpmi.png" },
  { nome: "22º BPM/M", imagem: "assets/brasao_22bpm.png" }
];

const selectBatalhao = document.getElementById("selectBatalhao");

function carregarBatalhoes(lista) {
  selectBatalhao.innerHTML = '<option value="">Selecionar batalhão</option>';

  lista.forEach((b, index) => {
    const option = document.createElement("option");
    option.value = index;
    option.textContent = b.nome;
    selectBatalhao.appendChild(option);
  });
}

carregarBatalhoes(batalhoes);

// BUSCA
document.getElementById("buscaBatalhao").addEventListener("input", (e) => {
  const termo = e.target.value.toLowerCase();

  const filtrados = batalhoes.filter(b =>
    b.nome.toLowerCase().includes(termo)
  );

  carregarBatalhoes(filtrados);
});

// SELEÇÃO
selectBatalhao.addEventListener("change", (e) => {
  const index = e.target.value;
  if (index !== "") {
    estadoApp.batalhao = batalhoes[index];
  }
});

// TIPO
document.getElementById("tipoPolicia").addEventListener("change", (e) => {
  estadoApp.tipoPolicia = e.target.value;
});

// GERAR FICHA
function gerarFicha() {
  const foto = document.getElementById("foto").files[0];
  if (!foto) {
    alert("Selecione uma imagem");
    return;
  }

  const dados = {
    cia: cia.value,
    pelotao: pelotao.value,
    nome: nome.value,
    rg: rg.value,
    nascimento: nascimento.value,
    ocorrencia: ocorrencia.value,
    local: local.value,
    viatura: viatura.value,
    bopm: bopm.value,
    bopc: bopc.value,
    data: data.value,
  };

  const img = new Image();
  img.onload = () => {
    canvas.width = 1080;
    canvas.height = 1920;

    let ratio = Math.max(canvas.width / img.width, canvas.height / img.height);
    let x = (canvas.width - img.width * ratio) / 2;
    let y = (canvas.height - img.height * ratio) / 2;
    ctx.drawImage(img, x, y, img.width * ratio, img.height * ratio);

    const boxX = 40;
    const boxY = 1220;
    const boxW = canvas.width - 80;
    const boxH = 740;

    ctx.fillStyle = "#fff";
    roundRect(ctx, boxX, boxY, boxW, boxH, 32, true);

    ctx.textAlign = "center";
    ctx.fillStyle = "#000";

    ctx.font = "bold 42px PMESP";
    ctx.fillText("POLÍCIA MILITAR DO ESTADO DE SÃO PAULO", canvas.width / 2, boxY + 62);

    const brasao1 = new Image();
    const brasao2 = new Image();

    brasao1.src = estadoApp.batalhao
      ? estadoApp.batalhao.imagem
      : "assets/brasao_22bpm.png";

    brasao2.src = estadoApp.tipoPolicia === "forca"
      ? "assets/forca.png"
      : "assets/brasao_pmesp.png";

    const tamanhoBrasao = 188;
    const offsetTopo = boxY + 104;
    const margemLateral = 60;

    brasao1.onload = () => {
      ctx.drawImage(brasao1, boxX + margemLateral, offsetTopo, tamanhoBrasao, tamanhoBrasao);
    };

    brasao2.onload = () => {
      ctx.drawImage(
        brasao2,
        boxX + boxW - margemLateral - tamanhoBrasao,
        offsetTopo,
        tamanhoBrasao,
        tamanhoBrasao
      );
    };

    ctx.font = "bold 34px PMESP";

    let textoPelotao = dados.pelotao.includes("Pelotão")
      ? dados.pelotao
      : `Pelotão ${dados.pelotao}`;

    ctx.fillText(textoPelotao, canvas.width / 2, boxY + 178);

    ctx.font = "28px PMESP";
    ctx.fillText(dados.cia, canvas.width / 2, boxY + 220);

    ctx.font = "35px PMESP";
    ctx.fillText(dados.nome, canvas.width / 2, boxY + 262);

    drawLinhaTexto(canvas.width / 2, boxY + 280, "Nome");

    let startY = boxY + 360;

    drawCampo("RG", dados.rg, boxX + 220, startY);
    drawCampo("Nascimento", dados.nascimento, canvas.width / 2, startY);
    drawCampo("Ocorrência", dados.ocorrencia, boxX + boxW - 220, startY);

    startY += 120;
    drawCampo("Local", dados.local, boxX + 300, startY);
    drawCampo("Viatura", dados.viatura, boxX + boxW - 300, startY);

    startY += 120;
    drawCampo("BOPM", dados.bopm, boxX + 220, startY);
    drawCampo("BOPC", dados.bopc, canvas.width / 2, startY);
    drawCampo("Data", dados.data, boxX + boxW - 220, startY);

    document.getElementById("acoes").hidden = false;
  };

  img.src = URL.createObjectURL(foto);
}

// AUX
function drawCampo(label, valor, x, y) {
  ctx.font = "35px PMESP";
  ctx.fillText(valor, x, y);

  ctx.beginPath();
  ctx.moveTo(x - 100, y + 12);
  ctx.lineTo(x + 100, y + 12);
  ctx.stroke();

  ctx.font = "30px PMESP";
  ctx.fillText(label, x, y + 40);
}

function drawLinhaTexto(x, y, texto) {
  ctx.beginPath();
  ctx.moveTo(x - 170, y);
  ctx.lineTo(x + 170, y);
  ctx.stroke();

  ctx.font = "20px PMESP";
  ctx.fillText(texto, x, y + 30);
}

function roundRect(ctx, x, y, w, h, r, fill) {
  ctx.beginPath();
  ctx.moveTo(x + r, y);
  ctx.lineTo(x + w - r, y);
  ctx.quadraticCurveTo(x + w, y, x + w, y + r);
  ctx.lineTo(x + w, y + h - r);
  ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
  ctx.lineTo(x + r, y + h);
  ctx.quadraticCurveTo(x, y + h, x, y + h - r);
  ctx.lineTo(x, y + r);
  ctx.quadraticCurveTo(x, y, x + r, y);
  ctx.closePath();
  if (fill) ctx.fill();
}

function baixar() {
  const link = document.createElement("a");
  link.download = "photobravo.png";
  link.href = canvas.toDataURL("image/png");
  link.click();
}

function compartilhar() {
  canvas.toBlob(blob => {
    const file = new File([blob], "photobravo.png", { type: "image/png" });

    if (navigator.share && navigator.canShare && navigator.canShare({ files: [file] })) {
      navigator.share({
        files: [file],
        title: "Ficha PhotoBravo"
      });
    } else {
      const link = document.createElement("a");
      link.download = "photobravo.png";
      link.href = canvas.toDataURL("image/png");
      link.click();

      alert("Compartilhamento não suportado. A imagem foi baixada.");
    }
  });
}

// ===== SERVICE WORKER =====
if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("service-worker.js")
    .then(() => console.log("Service Worker registrado"))
    .catch(err => console.log("Erro SW:", err));
}