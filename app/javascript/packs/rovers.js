// import { Rekapi, Actor, CanvasRenderer, DOMRenderer } from 'rekapi';

// let xSize
// let ySize
// let bw = 500;
// let width_increment
// // Box height
// let bh = 500;
// let height_increment
// // Padding
// let p = 0;

// const arrowUp = '\uf062';
// const arrowDown = '\uf063';
// const arrowLeft = '\uf060';
// const arrowRight = '\uf061';

// let canvas
// let context

// window.renderGrid = function go(xSize, ySize, rovers) {
//   const rekapi = new Rekapi();
//   console.log(decodeURI(rovers));
//   width_increment = bw / xSize
//   // Box height
//   height_increment = bw / ySize
//   // Padding
//   p = 0;

//   canvas = document.getElementById("canvas");
//   context = canvas.getContext("2d");

//   rekapi.canvasRenderer = new CanvasRenderer(rekapi, context);
//   rekapi.canvasRenderer.height(bh);
//   rekapi.canvasRenderer.width(bw);

//   rekapi.domRenderer = new DOMRenderer(rekapi);

//   const canvasActor = rekapi.addActor({
//     context: context,

//     render: (context, state) => {
//       if (isNaN(state.x)) {
//         return;
//       }

//       // context.beginPath();
//       for (let x = 0; x <= bw; x += width_increment) {
//         context.moveTo(0.5 + x + p, p);
//         context.lineTo(0.5 + x + p, bh + p);
//       }

//       for (let x = 0; x <= bh; x += height_increment) {
//         context.moveTo(p, 0.5 + x + p);
//         context.lineTo(bw + p, 0.5 + x + p);
//       }
//       context.strokeStyle = "black";
//       context.stroke();
//       // context.closePath();
//     }
//   });

//   const domActor = rekapi.addActor({
//     context: document.querySelector('#dom-actor')
//   });

//   canvasActor
//     .keyframe(0, {
//       x: 50,
//       y: 50
//     })
//     .keyframe(1500, {
//       y: 250
//     });

//   domActor
//     .keyframe(0, {
//       transform: 'translateY(0px)'
//     }).keyframe(1500, {
//       transform: 'translateY(200px)'
//     });

//   // rekapi.play();
// }























// // import { Rekapi, Actor } from 'rekapi';
// // // Box width
// // let xSize
// // let ySize
// // let bw = 500;
// // let width_increment
// // // Box height
// // let bh = 500;
// // let height_increment
// // // Padding
// // let p = 0;

// // const arrowUp = '\uf062';
// // const arrowDown = '\uf063';
// // const arrowLeft = '\uf060';
// // const arrowRight = '\uf061';

// // let canvas
// // let context
// // // drawGrid = () => {
// // //   for (let x = 0; x <= bw; x += width_increment) {
// // //     context.moveTo(0.5 + x + p, p);
// // //     context.lineTo(0.5 + x + p, bh + p);
// // //   }

// // //   for (let x = 0; x <= bh; x += height_increment) {
// // //     context.moveTo(p, 0.5 + x + p);
// // //     context.lineTo(bw + p, 0.5 + x + p);
// // //   }
// // //   context.strokeStyle = "black";
// // //   context.stroke();
// // // };

// // function drawGrid(xSize, ySize) {
// //   width_increment = bw / xSize
// //   // Box height
// //   height_increment = bw / ySize
// //   // Padding
// //   p = 0;

// //   canvas = document.getElementById("canvas");
// //   context = canvas.getContext("2d");

// //   for (let x = 0; x <= bw; x += width_increment) {
// //     context.moveTo(0.5 + x + p, p);
// //     context.lineTo(0.5 + x + p, bh + p);
// //   }

// //   for (let x = 0; x <= bh; x += height_increment) {
// //     context.moveTo(p, 0.5 + x + p);
// //     context.lineTo(bw + p, 0.5 + x + p);
// //   }
// //   context.strokeStyle = "black";
// //   context.stroke();


// //   console.log('DRAW GRID');
// //   const rekapi = new Rekapi(context);
// //   const actor = new Actor({
// //     render: (context, state) => {
// //       // Rekapi was given a canvas as a context, so `context` here is a
// //       // CanvasRenderingContext2D.

// //       context.beginPath();
// //       context.arc(
// //         state.x,
// //         state.y,
// //         25,
// //         0,
// //         Math.PI*2,
// //         true
// //       );

// //       context.fillStyle = '#f0f';
// //       context.fill();
// //       context.closePath();
// //     }
// //   });
// //   // rekapi.addActor(actor);

// //   // actor.keyframe(0, {
// //   //   x: 50,
// //   //   y: 50
// //   // })
// //   // .keyframe(1000, {
// //   //   x: 200,
// //   //   y: 100
// //   // }, 'easeOutExpo');
// //   // rekapi.play();
// // };

// // function getBox(x, y) {
// //   console.log(context);
// // };

// // function placeRover(rover) {
// //   console.log(rovers)
// //   const p = context.lineWidth / 2;
// //   const startX = rover.start_x * width_increment + (width_increment/2)
// //   const startY = rover.start_y * height_increment + (height_increment/2)
// //   console.log(startX);
// //   console.log(startY);
// //   context.font='14px FontAwesome';
// //   context.fillText(arrowUp, startX, startY);
// //   // for (let xCell = 0; xCell < xSize; xCell++) {
// //   //   for (let yCell = 0; yCell < ySize; yCell++) {
// //   //     const x = xCell * width_increment;
// //   //     const y = yCell * height_increment;
// //   //     context.fillText('test', x+(width_increment/2), y+(height_increment/2));
// //   //   };
// //   // };
// //   // const rover = rovers[index];
// //   // getBox(rover.start_x, rover.start_y);
// // };

// // function moveRover(rover) {

// // };

// // // drawGrid();


// // // for (let rover = 0; rover < '<%= @command.rovers.count %>'; rover += 1) {
// // //   placeRover(rover)
// // // }

// // document.addEventListener("turbolinks:load", () => {
// //   drawGrid(5, 5);
// // })
