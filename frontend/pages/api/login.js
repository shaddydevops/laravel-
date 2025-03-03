// import withSession from '@/lib/session'
// import axios from 'axios';


// export default withSession(async (req, res) => {
//     const {username, password} = await req.body
//     const loginUrl = process.env.BACKEND_API_HOST+'/api/login';


//     try {
//         const response = await axios.post(loginUrl, {username: username, password: password});

//         if (response.status === 200) {
//             const {user, api_token} = response.data;

//             req.session.set('user', user)
//             req.session.set('api_token', api_token)
//             await req.session.save()
//             return res.json({logged_in: true});
//         }

//         const status = response.data.message;
//         const errors = response.data.errors;
//         return res.json({status, logged_in: false, errors});

//     } catch (err) {
//         let status = 'Something went wrong';
//         let errors = null;

//         console.log(err);
//         if (err.response) {
//             status = err.response.data.message;
//             errors = err.response.data.errors;
//         }
//         return res.json({logged_in: false, status, errors: errors});
//     }


// // })

// import withSession from '@/lib/session'
// import axios from 'axios'

// export default withSession(async (req, res) => {
//     const { username, password } = req.body
//     const API_URL = process.env.NEXT_PUBLIC_API_URL || process.env.NEXT_PUBLIC_API_URL_LOCAL
//     const loginUrl = `${API_URL}/api/login`

//     try {
//         const response = await axios.post(loginUrl, { username, password })

//         if (response.status === 200) {
//             const { user, api_token } = response.data
//             req.session.set('user', user)
//             req.session.set('api_token', api_token)
//             await req.session.save()
//             return res.json({ logged_in: true })
//         }

//         // Handle other status codes
//         return res.status(response.status).json({
//             logged_in: false,
//             status: response.data.message,
//             errors: response.data.errors
//         })

//     } catch (err) {
//         // Improved error handling
//         console.error('Login error:', err)
//         const status = err.response?.data?.message || 'Something went wrong'
//         const errors = err.response?.data?.errors || null
//         return res.status(err.response?.status || 500).json({
//             logged_in: false,
//             status,
//             errors
//         })
//     }
// })

import withSession from '@/lib/session';
import axios from 'axios';

export default withSession(async (req, res) => {
    const { username, password } = req.body;

    // Use the correct environment variable for the backend URL
    const API_URL = process.env.NEXT_PUBLIC_API_URL || process.env.NEXT_PUBLIC_API_URL_LOCAL;
    const loginUrl = `${API_URL}/login`; // Ensure the URL is correct

    console.log('Sending login request to:', loginUrl); // Debugging: Log the backend URL

    try {
        const response = await axios.post(loginUrl, { username, password });

        console.log('Login response:', response.data); // Debugging: Log the response

        if (response.status === 200) {
            const { user, api_token } = response.data;

            // Save user session
            req.session.set('user', user);
            req.session.set('api_token', api_token);
            await req.session.save();

            return res.json({ logged_in: true });
        }

        // Handle other status codes
        return res.status(response.status).json({
            logged_in: false,
            status: response.data.message,
            errors: response.data.errors,
        });

    } catch (err) {
        // Improved error handling
        console.error('Login error:', err);

        const status = err.response?.data?.message || 'Something went wrong';
        const errors = err.response?.data?.errors || null;

        return res.status(err.response?.status || 500).json({
            logged_in: false,
            status,
            errors,
        });
    }
});