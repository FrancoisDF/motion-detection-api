import * as nodemailer from "nodemailer";

const EMAIL = `
  <h1>Une persone est dans le jardin</h1>
  <img  style="width:250px;" src="cid:unique@cid"/>
`;

export const sendEmail = (email: string, image: any) => {
  // create reusable transporter object using the default SMTP transport
  const transporter = nodemailer.createTransport({
    host: process.env.MAIL_HOST,
    auth: {
      user: process.env.MAIL_USER,
      pass: process.env.MAIL_PASS
    }
  });

  // send mail with defined transport object
  transporter.sendMail({
    from: process.env.MAIL_FROM,
    to: email,
    subject: "Security", // Subject line
    html: EMAIL,
    attachments: [{
      filename: 'intruder.jpeg',
      content: image,
      cid: 'unique@cid' // same cid value as in the html img src
    }]
  });
};
