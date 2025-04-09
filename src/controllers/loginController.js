import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export const mainFile = async (req, res) => {
    res.sendFile(path.join(__dirname, '../views/login.html'));
};

export const getIp = async (req, res) => {
    let ip =
        req.headers['x-forwarded-proto'] ||
        req.headers['cf-connecting-ip'] ||
        req.headers['x-real-ip'] ||
        req.headers['x-forwarded-for'] ||
        req.socket.remoteAddress ||
        '';

    if (ip == '::1') { //por ser server local siempre mandará ::1, el cual es equivalente a '127.0.0.1'
        ip = '127.0.0.1';
    }

    res.send(ip);
};