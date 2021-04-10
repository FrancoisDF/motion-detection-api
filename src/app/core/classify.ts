// import * as tf from '@tensorflow/tfjs-node';
import * as tf from '@tensorflow/tfjs';
import * as cocoSsd from '@tensorflow-models/coco-ssd';
import fetch from 'node-fetch';
import * as fs from 'fs';
import * as jpeg from 'jpeg-js';

export declare interface IPrediction {
  bbox: number[];
  class: string,
  score: number
}


export class Classify {
  private mnModel: any;
  private numChannels: number = 3;
  private predictions: IPrediction[];

  constructor() {
    console.log("Classify")
    this.mnModel = cocoSsd.load();
  }

  public async detect(buffer: any, classDetect: string): Promise<IPrediction[]|undefined> {
    const image = jpeg.decode(buffer, true);
    const input = this.imageToInput(image);
    const model = await this.mnModel;
    this.predictions = await model.detect(input);
    return Promise.resolve(this.predictions.filter((pred) => (pred.class === classDetect)));
  }

  public async loadImage(path: any): Promise<Buffer>{
    return new Promise((resolve, reject) => {
      if(path.includes('http')) {
        // Load image from URL
        fetch(path).then((res: any) => res.buffer()).then((data: Buffer) => {
          resolve(data);
        }).catch(err => {
          reject(err)
        })
      } else {
        // Load image from local file
        fs.readFile(path, (err, data) => {
          if (err){
            reject(err);
          }
          resolve(data);
        });
      }
    });
  }

  private imageByteArray(image: jpeg.UintArrRet): any {
    const pixels = image.data
    const numPixels = image.width * image.height;
    const values = new Int32Array(numPixels * this.numChannels);

    for (let i = 0; i < numPixels; i++) {
      for (let channel = 0; channel < this.numChannels; ++channel) {
        values[i * this.numChannels + channel] = pixels[i * 4 + channel];
      }
    }
    return values
  }

  private imageToInput = (image: jpeg.UintArrRet) => {
    const values = this.imageByteArray(image)
    const outShape: [number, number, number] = [image.height, image.width, this.numChannels];
    const tensor3d = tf.tensor3d(values, outShape, 'int32');
    return tensor3d;
  }
}
