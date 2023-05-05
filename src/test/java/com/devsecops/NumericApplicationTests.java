package com.devsecops;


import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
//import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
//import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

@RunWith(SpringRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
public class NumericApplicationTests {

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void smallerThanOrEqualToFiftyMessageTest() throws Exception {
        this.mockMvc.perform(get("/compare/50")).andDo(print()).andExpect(status().isOk())
                .andExpect(content().string("<h1>Smaller than or equal to 50</h1>"));
    }

    @Test
    public void greaterThanFiftyMessageTest() throws Exception {
        this.mockMvc.perform(get("/compare/51")).andDo(print()).andExpect(status().isOk())
                .andExpect(content().string("<h1>Greater than 50</h1>"));
    }

    @Test
    public void welcomeMessageTest() throws Exception {
        this.mockMvc.perform(get("/")).andDo(print()).andExpect(status().isOk())
                .andExpect(content().string("<h1>Kubernetes DevSecOps</h1>"));
    }
    

}