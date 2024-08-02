import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css'; // Import the CSS file for styling

const API_URL = 'http://localhost:8000/users';

function App() {
  const [users, setUsers] = useState([]);
  const [formData, setFormData] = useState({ id: '', name: '', email: '' });

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      const response = await axios.get(API_URL);
      setUsers(response.data);
    } catch (error) {
      console.error('Error fetching users:', error);
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleFormSubmit = async (e) => {
    e.preventDefault();
    try {
      if (formData.id) {
        // Update user
        await axios.put(`${API_URL}/${formData.id}`, formData);
      } else {
        // Create user
        await axios.post(API_URL, formData);
      }
      fetchUsers();
      setFormData({ id: '', name: '', email: '' });
    } catch (error) {
      console.error('Error saving user:', error);
    }
  };

  const handleEdit = (user) => {
    setFormData(user);
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`${API_URL}/${id}`);
      fetchUsers();
    } catch (error) {
      console.error('Error deleting user:', error);
    }
  };

  return (
    <div className="App">
      <h1>User Management</h1>
      <form onSubmit={handleFormSubmit} className="form-container">
        <input
          type="text"
          name="name"
          placeholder="Name"
          value={formData.name}
          onChange={handleInputChange}
          required
          className="form-input"
        />
        <input
          type="email"
          name="email"
          placeholder="Email"
          value={formData.email}
          onChange={handleInputChange}
          required
          className="form-input"
        />
        <button type="submit" className="form-button">
          {formData.id ? 'Update' : 'Create'}
        </button>
      </form>
      <table className="user-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {users.map((user) => (
            <tr key={user.id}>
              <td>{user.id}</td>
              <td>{user.name}</td>
              <td>{user.email}</td>
              <td>
                <button onClick={() => handleEdit(user)} className="action-button">Edit</button>
                <button onClick={() => handleDelete(user.id)} className="action-button">Delete</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default App;
